#!/usr/bin/env python3
import fnmatch
import socketserver
import time


store = {}
expires = {}


def purge(key):
    deadline = expires.get(key)
    if deadline is not None and deadline <= time.time():
        store.pop(key, None)
        expires.pop(key, None)
        return True
    return False


def encode(value):
    if value is None:
        return b"$-1\r\n"
    if isinstance(value, bytes):
        return b"$%d\r\n" % len(value) + value + b"\r\n"
    if isinstance(value, int):
        return b":%d\r\n" % value
    if isinstance(value, str):
        return b"+" + value.encode() + b"\r\n"
    if isinstance(value, list):
        return b"*" + str(len(value)).encode() + b"\r\n" + b"".join(encode(v) for v in value)
    return b"+" + str(value).encode() + b"\r\n"


class RedisHandler(socketserver.StreamRequestHandler):
    def read_command(self):
        line = self.rfile.readline()
        if not line:
            return None
        if line.startswith(b"*"):
            count = int(line[1:])
            parts = []
            for _ in range(count):
                length_line = self.rfile.readline()
                if not length_line.startswith(b"$"):
                    return None
                length = int(length_line[1:])
                data = self.rfile.read(length)
                self.rfile.read(2)
                parts.append(data)
            return parts
        return line.strip().split()

    def handle(self):
        while True:
            command = self.read_command()
            if not command:
                return
            name = command[0].decode(errors="ignore").upper()
            args = command[1:]
            try:
                self.wfile.write(self.dispatch(name, args))
            except Exception as exc:
                self.wfile.write(b"-ERR " + str(exc).encode() + b"\r\n")

    def dispatch(self, name, args):
        if name in {"PING", "AUTH", "SELECT", "CLIENT", "CONFIG"}:
            return encode("OK")
        if name == "HELLO":
            return encode(["server", "redis", "version", "7.0.0", "proto", 2])
        if name == "QUIT":
            return encode("OK")
        if name == "SET":
            key, value = args[0], args[1]
            store[key] = value
            expires.pop(key, None)
            upper = [a.upper() for a in args[2:]]
            if b"EX" in upper:
                expires[key] = time.time() + int(args[2 + upper.index(b"EX") + 1])
            if b"PX" in upper:
                expires[key] = time.time() + int(args[2 + upper.index(b"PX") + 1]) / 1000
            return encode("OK")
        if name == "GET":
            key = args[0]
            purge(key)
            return encode(store.get(key))
        if name == "DEL":
            removed = 0
            for key in args:
                removed += 1 if store.pop(key, None) is not None else 0
                expires.pop(key, None)
            return encode(removed)
        if name == "EXISTS":
            return encode(sum(0 if purge(key) or key not in store else 1 for key in args))
        if name == "EXPIRE":
            key, seconds = args[0], int(args[1])
            if purge(key) or key not in store:
                return encode(0)
            expires[key] = time.time() + seconds
            return encode(1)
        if name == "TTL":
            key = args[0]
            if purge(key) or key not in store:
                return encode(-2)
            if key not in expires:
                return encode(-1)
            return encode(max(0, int(expires[key] - time.time())))
        if name == "KEYS":
            pattern = args[0].decode(errors="ignore")
            keys = []
            for key in list(store.keys()):
                if not purge(key) and fnmatch.fnmatch(key.decode(errors="ignore"), pattern):
                    keys.append(key)
            return encode(keys)
        if name == "DBSIZE":
            for key in list(store.keys()):
                purge(key)
            return encode(len(store))
        if name == "INCR":
            key = args[0]
            value = int(store.get(key, b"0")) + 1
            store[key] = str(value).encode()
            return encode(value)
        if name == "TYPE":
            key = args[0]
            return encode("none" if purge(key) or key not in store else "string")
        if name == "INFO":
            return encode(b"redis_version:7.0.0\r\nconnected_clients:1\r\ndb0:keys=%d,expires=%d,avg_ttl=0\r\n" % (len(store), len(expires)))
        if name == "EVAL":
            # RuoYi's rate limiter script only needs an integer result for local dev.
            return encode(1)
        return encode("OK")


if __name__ == "__main__":
    server = socketserver.ThreadingTCPServer(("127.0.0.1", 6379), RedisHandler)
    server.allow_reuse_address = True
    print("mini redis listening on 127.0.0.1:6379", flush=True)
    server.serve_forever()
