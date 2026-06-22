-- ----------------------------
-- 1、部门表
-- ----------------------------
drop table if exists sys_dept;
create table sys_dept (
  dept_id           bigint      not null auto_increment,
  parent_id         bigint      default 0,
  ancestors         varchar(50)     default '',
  dept_name         varchar(30)     default '',
  order_num         int          default 0,
  leader            varchar(20)     default null,
  phone             varchar(11)     default null,
  email             varchar(50)     default null,
  status            char(1)         default '0',
  del_flag          char(1)         default '0',
  create_by         varchar(64)     default '',
  create_time 	    timestamp,
  update_by         varchar(64)     default '',
  update_time       timestamp,
  primary key (dept_id)
);

-- ----------------------------
-- 初始化-部门表数据
-- ----------------------------
insert into sys_dept values(100,  0,   '0',          '科技',   0, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', CURRENT_TIMESTAMP(), '', null);
insert into sys_dept values(101,  100, '0,100',      '深圳总公司', 1, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', CURRENT_TIMESTAMP(), '', null);
insert into sys_dept values(102,  100, '0,100',      '长沙分公司', 2, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', CURRENT_TIMESTAMP(), '', null);
insert into sys_dept values(103,  101, '0,100,101',  '研发部门',   1, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', CURRENT_TIMESTAMP(), '', null);
insert into sys_dept values(104,  101, '0,100,101',  '市场部门',   2, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', CURRENT_TIMESTAMP(), '', null);
insert into sys_dept values(105,  101, '0,100,101',  '测试部门',   3, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', CURRENT_TIMESTAMP(), '', null);
insert into sys_dept values(106,  101, '0,100,101',  '财务部门',   4, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', CURRENT_TIMESTAMP(), '', null);
insert into sys_dept values(107,  101, '0,100,101',  '运维部门',   5, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', CURRENT_TIMESTAMP(), '', null);
insert into sys_dept values(108,  102, '0,100,102',  '市场部门',   1, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', CURRENT_TIMESTAMP(), '', null);
insert into sys_dept values(109,  102, '0,100,102',  '财务部门',   2, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', CURRENT_TIMESTAMP(), '', null);


-- ----------------------------
-- 2、用户信息表
-- ----------------------------
drop table if exists sys_user;
create table sys_user (
  user_id           bigint      not null auto_increment,
  dept_id           bigint      default null,
  user_name         varchar(30)     not null,
  nick_name         varchar(30)     not null,
  user_type         varchar(2)      default '00',
  email             varchar(50)     default '',
  phonenumber       varchar(11)     default '',
  sex               char(1)         default '0',
  avatar            varchar(100)    default '',
  password          varchar(100)    default '',
  status            char(1)         default '0',
  del_flag          char(1)         default '0',
  login_ip          varchar(128)    default '',
  login_date        timestamp,
  pwd_update_date   timestamp,
  create_by         varchar(64)     default '',
  create_time       timestamp,
  update_by         varchar(64)     default '',
  update_time       timestamp,
  rfid_card         varchar(64)     default null,
  remark            varchar(500)    default null,
  primary key (user_id)
);

-- ----------------------------
-- 初始化-用户信息表数据
-- ----------------------------
insert into sys_user values(1,  103, 'admin', '', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 'admin', CURRENT_TIMESTAMP(), '', null, 'RFID-ADMIN-001', '管理员');
insert into sys_user values(2,  105, 'ry',    '', '00', 'ry@qq.com',  '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 'admin', CURRENT_TIMESTAMP(), '', null, 'RFID-OP-001', '测试员');


-- ----------------------------
-- 3、岗位信息表
-- ----------------------------
drop table if exists sys_post;
create table sys_post
(
  post_id       bigint      not null auto_increment,
  post_code     varchar(64)     not null,
  post_name     varchar(50)     not null,
  post_sort     int          not null,
  status        char(1)         not null,
  create_by     varchar(64)     default '',
  create_time   timestamp,
  update_by     varchar(64)     default '',
  update_time   timestamp,
  remark        varchar(500)    default null,
  primary key (post_id)
);

-- ----------------------------
-- 初始化-岗位信息表数据
-- ----------------------------
insert into sys_post values(1, 'ceo',  '董事长',    1, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_post values(2, 'se',   '项目经理',  2, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_post values(3, 'hr',   '人力资源',  3, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_post values(4, 'user', '普通员工',  4, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '');


-- ----------------------------
-- 4、角色信息表
-- ----------------------------
drop table if exists sys_role;
create table sys_role (
  role_id              bigint      not null auto_increment,
  role_name            varchar(30)     not null,
  role_key             varchar(100)    not null,
  role_sort            int          not null,
  data_scope           char(1)         default '1',
  menu_check_strictly  tinyint      default 1,
  dept_check_strictly  tinyint      default 1,
  status               char(1)         not null,
  del_flag             char(1)         default '0',
  create_by            varchar(64)     default '',
  create_time          timestamp,
  update_by            varchar(64)     default '',
  update_time          timestamp,
  remark               varchar(500)    default null,
  primary key (role_id)
);

-- ----------------------------
-- 初始化-角色信息表数据
-- ----------------------------
insert into sys_role values('1', '超级管理员',  'admin',  1, 1, 1, 1, '0', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '超级管理员');
insert into sys_role values('2', '普通角色',    'common', 2, 2, 1, 1, '0', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '普通角色');


-- ----------------------------
-- 5、菜单权限表
-- ----------------------------
drop table if exists sys_menu;
create table sys_menu (
  menu_id           bigint      not null auto_increment,
  menu_name         varchar(50)     not null,
  parent_id         bigint      default 0,
  order_num         int          default 0,
  path              varchar(200)    default '',
  component         varchar(255)    default null,
  query             varchar(255)    default null,
  route_name        varchar(50)     default '',
  is_frame          int          default 1,
  is_cache          int          default 0,
  menu_type         char(1)         default '',
  visible           char(1)         default 0,
  status            char(1)         default 0,
  perms             varchar(100)    default null,
  icon              varchar(100)    default '#',
  create_by         varchar(64)     default '',
  create_time       timestamp,
  update_by         varchar(64)     default '',
  update_time       timestamp,
  remark            varchar(500)    default '',
  primary key (menu_id)
);

-- ----------------------------
-- 初始化-菜单信息表数据
-- ----------------------------
-- 一级菜单
insert into sys_menu values('1', '系统管理', '0', '1', 'system',           null, '', '', 1, 0, 'M', '0', '0', '', 'system',   'admin', CURRENT_TIMESTAMP(), '', null, '系统管理目录');
insert into sys_menu values('2', '系统监控', '0', '2', 'monitor',          null, '', '', 1, 0, 'M', '0', '0', '', 'monitor',  'admin', CURRENT_TIMESTAMP(), '', null, '系统监控目录');
insert into sys_menu values('3', '系统工具', '0', '3', 'tool',             null, '', '', 1, 0, 'M', '0', '0', '', 'tool',     'admin', CURRENT_TIMESTAMP(), '', null, '系统工具目录');
insert into sys_menu values('4', '官网', '0', '4', 'http://ruoyi.vip', null, '', '', 0, 0, 'M', '0', '0', '', 'guide',    'admin', CURRENT_TIMESTAMP(), '', null, '官网地址');
-- 二级菜单
insert into sys_menu values('100',  '用户管理', '1',   '1', 'user',       'system/user/index',        '', '', 1, 0, 'C', '0', '0', 'system:user:list',        'user',          'admin', CURRENT_TIMESTAMP(), '', null, '用户管理菜单');
insert into sys_menu values('101',  '角色管理', '1',   '2', 'role',       'system/role/index',        '', '', 1, 0, 'C', '0', '0', 'system:role:list',        'peoples',       'admin', CURRENT_TIMESTAMP(), '', null, '角色管理菜单');
insert into sys_menu values('102',  '菜单管理', '1',   '3', 'menu',       'system/menu/index',        '', '', 1, 0, 'C', '0', '0', 'system:menu:list',        'tree-table',    'admin', CURRENT_TIMESTAMP(), '', null, '菜单管理菜单');
insert into sys_menu values('103',  '部门管理', '1',   '4', 'dept',       'system/dept/index',        '', '', 1, 0, 'C', '0', '0', 'system:dept:list',        'tree',          'admin', CURRENT_TIMESTAMP(), '', null, '部门管理菜单');
insert into sys_menu values('104',  '岗位管理', '1',   '5', 'post',       'system/post/index',        '', '', 1, 0, 'C', '0', '0', 'system:post:list',        'post',          'admin', CURRENT_TIMESTAMP(), '', null, '岗位管理菜单');
insert into sys_menu values('105',  '字典管理', '1',   '6', 'dict',       'system/dict/index',        '', '', 1, 0, 'C', '0', '0', 'system:dict:list',        'dict',          'admin', CURRENT_TIMESTAMP(), '', null, '字典管理菜单');
insert into sys_menu values('106',  '参数设置', '1',   '7', 'config',     'system/config/index',      '', '', 1, 0, 'C', '0', '0', 'system:config:list',      'edit',          'admin', CURRENT_TIMESTAMP(), '', null, '参数设置菜单');
insert into sys_menu values('107',  '通知公告', '1',   '8', 'notice',     'system/notice/index',      '', '', 1, 0, 'C', '0', '0', 'system:notice:list',      'message',       'admin', CURRENT_TIMESTAMP(), '', null, '通知公告菜单');
insert into sys_menu values('108',  '日志管理', '1',   '9', 'log',        '',                         '', '', 1, 0, 'M', '0', '0', '',                        'log',           'admin', CURRENT_TIMESTAMP(), '', null, '日志管理菜单');
insert into sys_menu values('118',  '编码规则', '1',   '10', 'codeRule',  'system/codeRule/index',    '', '', 1, 0, 'C', '0', '0', 'system:codeRule:list',    'number',        'admin', CURRENT_TIMESTAMP(), '', null, '编码规则菜单');
insert into sys_menu values('109',  '在线用户', '2',   '1', 'online',     'monitor/online/index',     '', '', 1, 0, 'C', '0', '0', 'monitor:online:list',     'online',        'admin', CURRENT_TIMESTAMP(), '', null, '在线用户菜单');
insert into sys_menu values('110',  '定时任务', '2',   '2', 'job',        'monitor/job/index',        '', '', 1, 0, 'C', '0', '0', 'monitor:job:list',        'job',           'admin', CURRENT_TIMESTAMP(), '', null, '定时任务菜单');
insert into sys_menu values('111',  '数据监控', '2',   '3', 'druid',      'monitor/druid/index',      '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list',      'druid',         'admin', CURRENT_TIMESTAMP(), '', null, '数据监控菜单');
insert into sys_menu values('112',  '服务监控', '2',   '4', 'server',     'monitor/server/index',     '', '', 1, 0, 'C', '0', '0', 'monitor:server:list',     'server',        'admin', CURRENT_TIMESTAMP(), '', null, '服务监控菜单');
insert into sys_menu values('113',  '缓存监控', '2',   '5', 'cache',      'monitor/cache/index',      '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list',      'redis',         'admin', CURRENT_TIMESTAMP(), '', null, '缓存监控菜单');
insert into sys_menu values('114',  '缓存列表', '2',   '6', 'cacheList',  'monitor/cache/list',       '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list',      'redis-list',    'admin', CURRENT_TIMESTAMP(), '', null, '缓存列表菜单');
insert into sys_menu values('115',  '表单构建', '3',   '1', 'build',      'tool/build/index',         '', '', 1, 0, 'C', '0', '0', 'tool:build:list',         'build',         'admin', CURRENT_TIMESTAMP(), '', null, '表单构建菜单');
insert into sys_menu values('116',  '代码生成', '3',   '2', 'gen',        'tool/gen/index',           '', '', 1, 0, 'C', '0', '0', 'tool:gen:list',           'code',          'admin', CURRENT_TIMESTAMP(), '', null, '代码生成菜单');
insert into sys_menu values('117',  '系统接口', '3',   '3', 'swagger',    'tool/swagger/index',       '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list',       'swagger',       'admin', CURRENT_TIMESTAMP(), '', null, '系统接口菜单');
-- 三级菜单
insert into sys_menu values('500',  '操作日志', '108', '1', 'operlog',    'monitor/operlog/index',    '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list',    'form',          'admin', CURRENT_TIMESTAMP(), '', null, '操作日志菜单');
insert into sys_menu values('501',  '登录日志', '108', '2', 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor',    'admin', CURRENT_TIMESTAMP(), '', null, '登录日志菜单');
-- 用户管理按钮
insert into sys_menu values('1000', '用户查询', '100', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query',          '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1001', '用户新增', '100', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add',            '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1002', '用户修改', '100', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit',           '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1003', '用户删除', '100', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove',         '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1004', '用户导出', '100', '5',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export',         '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1005', '用户导入', '100', '6',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import',         '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1006', '重置密码', '100', '7',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd',       '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
-- 角色管理按钮
insert into sys_menu values('1007', '角色查询', '101', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query',          '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1008', '角色新增', '101', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add',            '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1009', '角色修改', '101', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit',           '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1010', '角色删除', '101', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove',         '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1011', '角色导出', '101', '5',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export',         '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
-- 菜单管理按钮
insert into sys_menu values('1012', '菜单查询', '102', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query',          '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1013', '菜单新增', '102', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add',            '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1014', '菜单修改', '102', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit',           '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1015', '菜单删除', '102', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove',         '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
-- 部门管理按钮
insert into sys_menu values('1016', '部门查询', '103', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query',          '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1017', '部门新增', '103', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add',            '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1018', '部门修改', '103', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit',           '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1019', '部门删除', '103', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove',         '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
-- 岗位管理按钮
insert into sys_menu values('1020', '岗位查询', '104', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query',          '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1021', '岗位新增', '104', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add',            '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1022', '岗位修改', '104', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit',           '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1023', '岗位删除', '104', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove',         '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1024', '岗位导出', '104', '5',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export',         '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
-- 字典管理按钮
insert into sys_menu values('1025', '字典查询', '105', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query',          '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1026', '字典新增', '105', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add',            '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1027', '字典修改', '105', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit',           '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1028', '字典删除', '105', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove',         '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1029', '字典导出', '105', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export',         '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
-- 参数设置按钮
insert into sys_menu values('1030', '参数查询', '106', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query',        '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1031', '参数新增', '106', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add',          '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1032', '参数修改', '106', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit',         '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1033', '参数删除', '106', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove',       '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1034', '参数导出', '106', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export',       '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
-- 通知公告按钮
insert into sys_menu values('1035', '公告查询', '107', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query',        '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1036', '公告新增', '107', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add',          '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1037', '公告修改', '107', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit',         '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1038', '公告删除', '107', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove',       '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
-- 操作日志按钮
insert into sys_menu values('1039', '操作查询', '500', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query',      '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1040', '操作删除', '500', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove',     '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1041', '日志导出', '500', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export',     '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
-- 登录日志按钮
insert into sys_menu values('1042', '登录查询', '501', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query',   '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1043', '登录删除', '501', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove',  '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1044', '日志导出', '501', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export',  '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1045', '账户解锁', '501', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock',  '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
-- 在线用户按钮
insert into sys_menu values('1046', '在线查询', '109', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query',       '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1047', '批量强退', '109', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1048', '单条强退', '109', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
-- 定时任务按钮
insert into sys_menu values('1049', '任务查询', '110', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query',          '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1050', '任务新增', '110', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add',            '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1051', '任务修改', '110', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit',           '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1052', '任务删除', '110', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove',         '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1053', '状态修改', '110', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus',   '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1054', '任务导出', '110', '6', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export',         '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
-- 代码生成按钮
insert into sys_menu values('1055', '生成查询', '116', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query',             '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1056', '生成修改', '116', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit',              '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1057', '生成删除', '116', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove',            '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1058', '导入代码', '116', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import',            '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1059', '预览代码', '116', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview',           '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1060', '生成代码', '116', '6', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code',              '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
-- 编码规则按钮
insert into sys_menu values('1070', '规则查询', '118', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:codeRule:query',      '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1071', '规则新增', '118', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:codeRule:add',        '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1072', '规则修改', '118', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:codeRule:edit',       '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1073', '规则删除', '118', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:codeRule:remove',     '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('1074', '规则导出', '118', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:codeRule:export',     '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');


-- ----------------------------
-- 6、用户和角色关联表  用户N-1角色
-- ----------------------------
drop table if exists sys_user_role;
create table sys_user_role (
  user_id   bigint not null,
  role_id   bigint not null,
  primary key(user_id, role_id)
);

-- ----------------------------
-- 初始化-用户和角色关联表数据
-- ----------------------------
insert into sys_user_role values ('1', '1');
insert into sys_user_role values ('2', '2');


-- ----------------------------
-- 7、角色和菜单关联表  角色1-N菜单
-- ----------------------------
drop table if exists sys_role_menu;
create table sys_role_menu (
  role_id   bigint not null,
  menu_id   bigint not null,
  primary key(role_id, menu_id)
);

-- ----------------------------
-- 初始化-角色和菜单关联表数据
-- ----------------------------
insert into sys_role_menu values ('2', '1');
insert into sys_role_menu values ('2', '2');
insert into sys_role_menu values ('2', '3');
insert into sys_role_menu values ('2', '4');
insert into sys_role_menu values ('2', '100');
insert into sys_role_menu values ('2', '101');
insert into sys_role_menu values ('2', '102');
insert into sys_role_menu values ('2', '103');
insert into sys_role_menu values ('2', '104');
insert into sys_role_menu values ('2', '105');
insert into sys_role_menu values ('2', '106');
insert into sys_role_menu values ('2', '107');
insert into sys_role_menu values ('2', '108');
insert into sys_role_menu values ('2', '109');
insert into sys_role_menu values ('2', '110');
insert into sys_role_menu values ('2', '111');
insert into sys_role_menu values ('2', '112');
insert into sys_role_menu values ('2', '113');
insert into sys_role_menu values ('2', '114');
insert into sys_role_menu values ('2', '115');
insert into sys_role_menu values ('2', '116');
insert into sys_role_menu values ('2', '117');
insert into sys_role_menu values ('2', '500');
insert into sys_role_menu values ('2', '501');
insert into sys_role_menu values ('2', '1000');
insert into sys_role_menu values ('2', '1001');
insert into sys_role_menu values ('2', '1002');
insert into sys_role_menu values ('2', '1003');
insert into sys_role_menu values ('2', '1004');
insert into sys_role_menu values ('2', '1005');
insert into sys_role_menu values ('2', '1006');
insert into sys_role_menu values ('2', '1007');
insert into sys_role_menu values ('2', '1008');
insert into sys_role_menu values ('2', '1009');
insert into sys_role_menu values ('2', '1010');
insert into sys_role_menu values ('2', '1011');
insert into sys_role_menu values ('2', '1012');
insert into sys_role_menu values ('2', '1013');
insert into sys_role_menu values ('2', '1014');
insert into sys_role_menu values ('2', '1015');
insert into sys_role_menu values ('2', '1016');
insert into sys_role_menu values ('2', '1017');
insert into sys_role_menu values ('2', '1018');
insert into sys_role_menu values ('2', '1019');
insert into sys_role_menu values ('2', '1020');
insert into sys_role_menu values ('2', '1021');
insert into sys_role_menu values ('2', '1022');
insert into sys_role_menu values ('2', '1023');
insert into sys_role_menu values ('2', '1024');
insert into sys_role_menu values ('2', '1025');
insert into sys_role_menu values ('2', '1026');
insert into sys_role_menu values ('2', '1027');
insert into sys_role_menu values ('2', '1028');
insert into sys_role_menu values ('2', '1029');
insert into sys_role_menu values ('2', '1030');
insert into sys_role_menu values ('2', '1031');
insert into sys_role_menu values ('2', '1032');
insert into sys_role_menu values ('2', '1033');
insert into sys_role_menu values ('2', '1034');
insert into sys_role_menu values ('2', '1035');
insert into sys_role_menu values ('2', '1036');
insert into sys_role_menu values ('2', '1037');
insert into sys_role_menu values ('2', '1038');
insert into sys_role_menu values ('2', '1039');
insert into sys_role_menu values ('2', '1040');
insert into sys_role_menu values ('2', '1041');
insert into sys_role_menu values ('2', '1042');
insert into sys_role_menu values ('2', '1043');
insert into sys_role_menu values ('2', '1044');
insert into sys_role_menu values ('2', '1045');
insert into sys_role_menu values ('2', '1046');
insert into sys_role_menu values ('2', '1047');
insert into sys_role_menu values ('2', '1048');
insert into sys_role_menu values ('2', '1049');
insert into sys_role_menu values ('2', '1050');
insert into sys_role_menu values ('2', '1051');
insert into sys_role_menu values ('2', '1052');
insert into sys_role_menu values ('2', '1053');
insert into sys_role_menu values ('2', '1054');
insert into sys_role_menu values ('2', '1055');
insert into sys_role_menu values ('2', '1056');
insert into sys_role_menu values ('2', '1057');
insert into sys_role_menu values ('2', '1058');
insert into sys_role_menu values ('2', '1059');
insert into sys_role_menu values ('2', '1060');

-- ----------------------------
-- 8、角色和部门关联表  角色1-N部门
-- ----------------------------
drop table if exists sys_role_dept;
create table sys_role_dept (
  role_id   bigint not null,
  dept_id   bigint not null,
  primary key(role_id, dept_id)
);

-- ----------------------------
-- 初始化-角色和部门关联表数据
-- ----------------------------
insert into sys_role_dept values ('2', '100');
insert into sys_role_dept values ('2', '101');
insert into sys_role_dept values ('2', '105');


-- ----------------------------
-- 9、用户与岗位关联表  用户1-N岗位
-- ----------------------------
drop table if exists sys_user_post;
create table sys_user_post
(
  user_id   bigint not null,
  post_id   bigint not null,
  primary key (user_id, post_id)
);

-- ----------------------------
-- 初始化-用户与岗位关联表数据
-- ----------------------------
insert into sys_user_post values ('1', '1');
insert into sys_user_post values ('2', '2');


-- ----------------------------
-- 10、操作日志记录
-- ----------------------------
drop table if exists sys_oper_log;
create table sys_oper_log (
  oper_id           bigint      not null auto_increment,
  title             varchar(50)     default '',
  business_type     int          default 0,
  method            varchar(200)    default '',
  request_method    varchar(10)     default '',
  operator_type     int          default 0,
  oper_name         varchar(50)     default '',
  dept_name         varchar(50)     default '',
  oper_url          varchar(255)    default '',
  oper_ip           varchar(128)    default '',
  oper_location     varchar(255)    default '',
  oper_param        varchar(2000)   default '',
  json_result       varchar(2000)   default '',
  status            int          default 0,
  error_msg         varchar(2000)   default '',
  oper_time         timestamp,
  cost_time         bigint      default 0,
  primary key (oper_id),
  key idx_sys_oper_log_bt (business_type),
  key idx_sys_oper_log_s  (status),
  key idx_sys_oper_log_ot (oper_time)
);


-- ----------------------------
-- 11、字典类型表
-- ----------------------------
drop table if exists sys_dict_type;
create table sys_dict_type
(
  dict_id          bigint      not null auto_increment,
  dict_name        varchar(100)    default '',
  dict_type        varchar(100)    default '',
  status           char(1)         default '0',
  create_by        varchar(64)     default '',
  create_time      timestamp,
  update_by        varchar(64)     default '',
  update_time      timestamp,
  remark           varchar(500)    default null,
  primary key (dict_id),
  unique (dict_type)
);

insert into sys_dict_type values(1,  '用户性别', 'sys_user_sex',        '0', 'admin', CURRENT_TIMESTAMP(), '', null, '用户性别列表');
insert into sys_dict_type values(2,  '菜单状态', 'sys_show_hide',       '0', 'admin', CURRENT_TIMESTAMP(), '', null, '菜单状态列表');
insert into sys_dict_type values(3,  '系统开关', 'sys_normal_disable',  '0', 'admin', CURRENT_TIMESTAMP(), '', null, '系统开关列表');
insert into sys_dict_type values(4,  '任务状态', 'sys_job_status',      '0', 'admin', CURRENT_TIMESTAMP(), '', null, '任务状态列表');
insert into sys_dict_type values(5,  '任务分组', 'sys_job_group',       '0', 'admin', CURRENT_TIMESTAMP(), '', null, '任务分组列表');
insert into sys_dict_type values(6,  '系统是否', 'sys_yes_no',          '0', 'admin', CURRENT_TIMESTAMP(), '', null, '系统是否列表');
insert into sys_dict_type values(7,  '通知类型', 'sys_notice_type',     '0', 'admin', CURRENT_TIMESTAMP(), '', null, '通知类型列表');
insert into sys_dict_type values(8,  '通知状态', 'sys_notice_status',   '0', 'admin', CURRENT_TIMESTAMP(), '', null, '通知状态列表');
insert into sys_dict_type values(9,  '操作类型', 'sys_oper_type',       '0', 'admin', CURRENT_TIMESTAMP(), '', null, '操作类型列表');
insert into sys_dict_type values(10, '系统状态', 'sys_common_status',   '0', 'admin', CURRENT_TIMESTAMP(), '', null, '登录状态列表');


-- ----------------------------
-- 12、字典数据表
-- ----------------------------
drop table if exists sys_dict_data;
create table sys_dict_data
(
  dict_code        bigint      not null auto_increment,
  dict_sort        int          default 0,
  dict_label       varchar(100)    default '',
  dict_value       varchar(100)    default '',
  dict_type        varchar(100)    default '',
  css_class        varchar(100)    default null,
  list_class       varchar(100)    default null,
  is_default       char(1)         default 'N',
  status           char(1)         default '0',
  create_by        varchar(64)     default '',
  create_time      timestamp,
  update_by        varchar(64)     default '',
  update_time      timestamp,
  remark           varchar(500)    default null,
  primary key (dict_code)
);

insert into sys_dict_data values(1,  1,  '男',       '0',       'sys_user_sex',        '',   '',        'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '性别男');
insert into sys_dict_data values(2,  2,  '女',       '1',       'sys_user_sex',        '',   '',        'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '性别女');
insert into sys_dict_data values(3,  3,  '未知',     '2',       'sys_user_sex',        '',   '',        'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '性别未知');
insert into sys_dict_data values(4,  1,  '显示',     '0',       'sys_show_hide',       '',   'primary', 'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '显示菜单');
insert into sys_dict_data values(5,  2,  '隐藏',     '1',       'sys_show_hide',       '',   'danger',  'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '隐藏菜单');
insert into sys_dict_data values(6,  1,  '正常',     '0',       'sys_normal_disable',  '',   'primary', 'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '正常状态');
insert into sys_dict_data values(7,  2,  '停用',     '1',       'sys_normal_disable',  '',   'danger',  'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '停用状态');
insert into sys_dict_data values(8,  1,  '正常',     '0',       'sys_job_status',      '',   'primary', 'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '正常状态');
insert into sys_dict_data values(9,  2,  '暂停',     '1',       'sys_job_status',      '',   'danger',  'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '停用状态');
insert into sys_dict_data values(10, 1,  '默认',     'DEFAULT', 'sys_job_group',       '',   '',        'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '默认分组');
insert into sys_dict_data values(11, 2,  '系统',     'SYSTEM',  'sys_job_group',       '',   '',        'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '系统分组');
insert into sys_dict_data values(12, 1,  '是',       'Y',       'sys_yes_no',          '',   'primary', 'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '系统默认是');
insert into sys_dict_data values(13, 2,  '否',       'N',       'sys_yes_no',          '',   'danger',  'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '系统默认否');
insert into sys_dict_data values(14, 1,  '通知',     '1',       'sys_notice_type',     '',   'warning', 'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '通知');
insert into sys_dict_data values(15, 2,  '公告',     '2',       'sys_notice_type',     '',   'success', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '公告');
insert into sys_dict_data values(16, 1,  '正常',     '0',       'sys_notice_status',   '',   'primary', 'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '正常状态');
insert into sys_dict_data values(17, 2,  '关闭',     '1',       'sys_notice_status',   '',   'danger',  'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '关闭状态');
insert into sys_dict_data values(18, 99, '其他',     '0',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '其他操作');
insert into sys_dict_data values(19, 1,  '新增',     '1',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '新增操作');
insert into sys_dict_data values(20, 2,  '修改',     '2',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '修改操作');
insert into sys_dict_data values(21, 3,  '删除',     '3',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '删除操作');
insert into sys_dict_data values(22, 4,  '授权',     '4',       'sys_oper_type',       '',   'primary', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '授权操作');
insert into sys_dict_data values(23, 5,  '导出',     '5',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '导出操作');
insert into sys_dict_data values(24, 6,  '导入',     '6',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '导入操作');
insert into sys_dict_data values(25, 7,  '强退',     '7',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '强退操作');
insert into sys_dict_data values(26, 8,  '生成代码', '8',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '生成操作');
insert into sys_dict_data values(27, 9,  '清空数据', '9',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '清空操作');
insert into sys_dict_data values(28, 1,  '成功',     '0',       'sys_common_status',   '',   'primary', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '正常状态');
insert into sys_dict_data values(29, 2,  '失败',     '1',       'sys_common_status',   '',   'danger',  'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '停用状态');


-- ----------------------------
-- 13、参数配置表
-- ----------------------------
drop table if exists sys_config;
create table sys_config (
  config_id         int          not null auto_increment,
  config_name       varchar(100)    default '',
  config_key        varchar(100)    default '',
  config_value      varchar(500)    default '',
  config_type       char(1)         default 'N',
  create_by         varchar(64)     default '',
  create_time       timestamp,
  update_by         varchar(64)     default '',
  update_time       timestamp,
  remark            varchar(500)    default null,
  primary key (config_id)
);

insert into sys_config values(1, '主框架页-默认皮肤样式名称',     'sys.index.skinName',               'skin-blue',     'Y', 'admin', CURRENT_TIMESTAMP(), '', null, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow' );
insert into sys_config values(2, '用户管理-账号初始密码',         'sys.user.initPassword',            '123456',        'Y', 'admin', CURRENT_TIMESTAMP(), '', null, '初始化密码 123456' );
insert into sys_config values(3, '主框架页-侧边栏主题',           'sys.index.sideTheme',              'theme-dark',    'Y', 'admin', CURRENT_TIMESTAMP(), '', null, '深色主题theme-dark，浅色主题theme-light' );
insert into sys_config values(4, '账号自助-验证码开关',           'sys.account.captchaEnabled',       'false',         'Y', 'admin', CURRENT_TIMESTAMP(), '', null, '是否开启验证码功能（true开启，false关闭）');
insert into sys_config values(5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser',         'false',         'Y', 'admin', CURRENT_TIMESTAMP(), '', null, '是否开启注册用户功能（true开启，false关闭）');
insert into sys_config values(6, '用户登录-黑名单列表',           'sys.login.blackIPList',            '',              'Y', 'admin', CURRENT_TIMESTAMP(), '', null, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
insert into sys_config values(7, '用户管理-初始密码修改策略',     'sys.account.initPasswordModify',   '1',             'Y', 'admin', CURRENT_TIMESTAMP(), '', null, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
insert into sys_config values(8, '用户管理-账号密码更新周期',     'sys.account.passwordValidateDays', '0',             'Y', 'admin', CURRENT_TIMESTAMP(), '', null, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');


-- ----------------------------
-- 14、系统访问记录
-- ----------------------------
drop table if exists sys_logininfor;
create table sys_logininfor (
  info_id        bigint     not null auto_increment,
  user_name      varchar(50)    default '',
  ipaddr         varchar(128)   default '',
  login_location varchar(255)   default '',
  browser        varchar(50)    default '',
  os             varchar(50)    default '',
  status         char(1)        default '0',
  msg            varchar(255)   default '',
  login_time     timestamp,
  primary key (info_id),
  key idx_sys_logininfor_s  (status),
  key idx_sys_logininfor_lt (login_time)
);


-- ----------------------------
-- 15、定时任务调度表
-- ----------------------------
drop table if exists sys_job;
create table sys_job (
  job_id              bigint    not null auto_increment,
  job_name            varchar(64)   default '',
  job_group           varchar(64)   default 'DEFAULT',
  invoke_target       varchar(500)  not null,
  cron_expression     varchar(255)  default '',
  misfire_policy      varchar(20)   default '3',
  concurrent          char(1)       default '1',
  status              char(1)       default '0',
  create_by           varchar(64)   default '',
  create_time         timestamp,
  update_by           varchar(64)   default '',
  update_time         timestamp,
  remark              varchar(500)  default '',
  primary key (job_id, job_name, job_group)
);

insert into sys_job values(1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams',        '0/10 * * * * ?', '3', '1', '1', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_job values(2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')',  '0/15 * * * * ?', '3', '1', '1', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_job values(3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)',  '0/20 * * * * ?', '3', '1', '1', 'admin', CURRENT_TIMESTAMP(), '', null, '');


-- ----------------------------
-- 16、定时任务调度日志表
-- ----------------------------
drop table if exists sys_job_log;
create table sys_job_log (
  job_log_id          bigint     not null auto_increment,
  job_name            varchar(64)    not null,
  job_group           varchar(64)    not null,
  invoke_target       varchar(500)   not null,
  job_message         varchar(500),
  status              char(1)        default '0',
  exception_info      varchar(2000)  default '',
  start_time          timestamp,
  end_time            timestamp,
  create_time         timestamp,
  primary key (job_log_id)
);


-- ----------------------------
-- 17、通知公告表
-- ----------------------------
drop table if exists sys_notice;
create table sys_notice (
  notice_id         int          not null auto_increment,
  notice_title      varchar(50)     not null,
  notice_type       char(1)         not null,
  notice_content    longblob        default null,
  status            char(1)         default '0',
  create_by         varchar(64)     default '',
  create_time       timestamp,
  update_by         varchar(64)     default '',
  update_time       timestamp,
  remark            varchar(255)    default null,
  primary key (notice_id)
);

-- ----------------------------
-- 初始化-公告信息表数据
-- ----------------------------
insert into sys_notice values('1', '温馨提醒：2018-07-01 新版本发布啦', '2', '新版本内容', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '管理员');
insert into sys_notice values('2', '维护通知：2018-07-01 系统凌晨维护', '1', '维护内容',   '0', 'admin', CURRENT_TIMESTAMP(), '', null, '管理员');
insert into sys_notice values('3', '开源框架介绍', '1', '<p><span style=\"color: rgb(230, 0, 0);\">项目介绍</span></p><p><font color=\"#333333\">RuoYi开源项目是为企业用户定制的后台脚手架框架，为企业打造的一站式解决方案，降低企业开发成本，提升开发效率。主要包括用户管理、角色管理、部门管理、菜单管理、参数管理、字典管理、</font><span style=\"color: rgb(51, 51, 51);\">岗位管理</span><span style=\"color: rgb(51, 51, 51);\">、定时任务</span><span style=\"color: rgb(51, 51, 51);\">、</span><span style=\"color: rgb(51, 51, 51);\">服务监控、登录日志、操作日志、代码生成等功能。其中，还支持多数据源、数据权限、国际化、Redis缓存、Docker部署、滑动验证码、第三方认证登录、分布式事务、</span><font color=\"#333333\">分布式文件存储</font><span style=\"color: rgb(51, 51, 51);\">、分库分表处理等技术特点。</span></p><p><img src=\"https://foruda.gitee.com/images/1773931848342439032/a4d22313_1815095.png\" style=\"width: 64px;\"><br></p><p><span style=\"color: rgb(230, 0, 0);\">官网及演示</span></p><p><span style=\"color: rgb(51, 51, 51);\">官网地址：&nbsp;</span><a href=\"http://ruoyi.vip\" target=\"_blank\">http://ruoyi.vip</a><a href=\"http://ruoyi.vip\" target=\"_blank\"></a></p><p><span style=\"color: rgb(51, 51, 51);\">文档地址：&nbsp;</span><a href=\"http://doc.ruoyi.vip\" target=\"_blank\">http://doc.ruoyi.vip</a><br></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【不分离版】：&nbsp;</span><a href=\"http://demo.ruoyi.vip\" target=\"_blank\">http://demo.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【分离版本】：&nbsp;</span><a href=\"http://vue.ruoyi.vip\" target=\"_blank\">http://vue.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【微服务版】：&nbsp;</span><a href=\"http://cloud.ruoyi.vip\" target=\"_blank\">http://cloud.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【移动端版】：&nbsp;</span><a href=\"http://h5.ruoyi.vip\" target=\"_blank\">http://h5.ruoyi.vip</a></p><p><br style=\"color: rgb(48, 49, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px;\"></p>', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '管理员');


-- ----------------------------
-- 18、公告已读记录表
-- ----------------------------
drop table if exists sys_notice_read;
create table sys_notice_read (
  read_id          bigint       not null auto_increment,
  notice_id        int           not null,
  user_id          bigint       not null,
  read_time        timestamp         not null,
  primary key (read_id),
  unique key uk_user_notice (user_id, notice_id)
);


-- ----------------------------
-- 19、代码生成业务表
-- ----------------------------
drop table if exists gen_table;
create table gen_table (
  table_id          bigint      not null auto_increment,
  table_name        varchar(200)    default '',
  table_comment     varchar(500)    default '',
  sub_table_name    varchar(64)     default null,
  sub_table_fk_name varchar(64)     default null,
  class_name        varchar(100)    default '',
  tpl_category      varchar(200)    default 'crud',
  tpl_web_type      varchar(30)     default '',
  package_name      varchar(100),
  module_name       varchar(30),
  business_name     varchar(30),
  function_name     varchar(50),
  function_author   varchar(50),
  gen_type          char(1)         default '0',
  gen_path          varchar(200)    default '/',
  options           varchar(1000),
  create_by         varchar(64)     default '',
  create_time 	    timestamp,
  update_by         varchar(64)     default '',
  update_time       timestamp,
  remark            varchar(500)    default null,
  primary key (table_id)
);


-- ----------------------------
-- 20、代码生成业务表字段
-- ----------------------------
drop table if exists gen_table_column;
create table gen_table_column (
  column_id         bigint      not null auto_increment,
  table_id          bigint,
  column_name       varchar(200),
  column_comment    varchar(500),
  column_type       varchar(100),
  java_type         varchar(500),
  java_field        varchar(200),
  is_pk             char(1),
  is_increment      char(1),
  is_required       char(1),
  is_insert         char(1),
  is_edit           char(1),
  is_list           char(1),
  is_query          char(1),
  query_type        varchar(200)    default 'EQ',
  html_type         varchar(200),
  dict_type         varchar(200)    default '',
  sort              int,
  create_by         varchar(64)     default '',
  create_time 	    timestamp,
  update_by         varchar(64)     default '',
  update_time       timestamp,
  primary key (column_id)
);DROP TABLE IF EXISTS QRTZ_FIRED_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_PAUSED_TRIGGER_GRPS;
DROP TABLE IF EXISTS QRTZ_SCHEDULER_STATE;
DROP TABLE IF EXISTS QRTZ_LOCKS;
DROP TABLE IF EXISTS QRTZ_SIMPLE_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_SIMPROP_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_CRON_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_BLOB_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_JOB_DETAILS;
DROP TABLE IF EXISTS QRTZ_CALENDARS;

-- ----------------------------
-- 1、存储每一个已配置的 jobDetail 的详细信息
-- ----------------------------
create table QRTZ_JOB_DETAILS (
    sched_name           varchar(120)    not null,
    job_name             varchar(200)    not null,
    job_group            varchar(200)    not null,
    description          varchar(250)    null,
    job_class_name       varchar(250)    not null,
    is_durable           varchar(1)      not null,
    is_nonconcurrent     varchar(1)      not null,
    is_update_data       varchar(1)      not null,
    requests_recovery    varchar(1)      not null,
    job_data             blob            null,
    primary key (sched_name, job_name, job_group)
);

-- ----------------------------
-- 2、 存储已配置的 Trigger 的信息
-- ----------------------------
create table QRTZ_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    job_name             varchar(200)    not null,
    job_group            varchar(200)    not null,
    description          varchar(250)    null,
    next_fire_time       bigint      null,
    prev_fire_time       bigint      null,
    priority             integer         null,
    trigger_state        varchar(16)     not null,
    trigger_type         varchar(8)      not null,
    start_time           bigint      not null,
    end_time             bigint      null,
    calendar_name        varchar(200)    null,
    misfire_instr        smallint     null,
    job_data             blob            null,
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, job_name, job_group) references QRTZ_JOB_DETAILS(sched_name, job_name, job_group)
);

-- ----------------------------
-- 3、 存储简单的 Trigger，包括重复次数，间隔，以及已触发的次数
-- ----------------------------
create table QRTZ_SIMPLE_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    repeat_count         bigint       not null,
    repeat_interval      bigint      not null,
    times_triggered      bigint      not null,
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
);

-- ----------------------------
-- 4、 存储 Cron Trigger，包括 Cron 表达式和时区信息
-- ---------------------------- 
create table QRTZ_CRON_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    cron_expression      varchar(200)    not null,
    time_zone_id         varchar(80),
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
);

-- ----------------------------
-- 5、 Trigger 作为 Blob 类型存储(用于 Quartz 用户用 JDBC 创建他们自己定制的 Trigger 类型，JobStore 并不知道如何存储实例的时候)
-- ---------------------------- 
create table QRTZ_BLOB_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    blob_data            blob            null,
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
);

-- ----------------------------
-- 6、 以 Blob 类型存储存放日历信息， quartz可配置一个日历来指定一个时间范围
-- ---------------------------- 
create table QRTZ_CALENDARS (
    sched_name           varchar(120)    not null,
    calendar_name        varchar(200)    not null,
    calendar             blob            not null,
    primary key (sched_name, calendar_name)
);

-- ----------------------------
-- 7、 存储已暂停的 Trigger 组的信息
-- ---------------------------- 
create table QRTZ_PAUSED_TRIGGER_GRPS (
    sched_name           varchar(120)    not null,
    trigger_group        varchar(200)    not null,
    primary key (sched_name, trigger_group)
);

-- ----------------------------
-- 8、 存储与已触发的 Trigger 相关的状态信息，以及相联 Job 的执行信息
-- ---------------------------- 
create table QRTZ_FIRED_TRIGGERS (
    sched_name           varchar(120)    not null,
    entry_id             varchar(95)     not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    instance_name        varchar(200)    not null,
    fired_time           bigint      not null,
    sched_time           bigint      not null,
    priority             integer         not null,
    state                varchar(16)     not null,
    job_name             varchar(200)    null,
    job_group            varchar(200)    null,
    is_nonconcurrent     varchar(1)      null,
    requests_recovery    varchar(1)      null,
    primary key (sched_name, entry_id)
);

-- ----------------------------
-- 9、 存储少量的有关 Scheduler 的状态信息，假如是用于集群中，可以看到其他的 Scheduler 实例
-- ---------------------------- 
create table QRTZ_SCHEDULER_STATE (
    sched_name           varchar(120)    not null,
    instance_name        varchar(200)    not null,
    last_checkin_time    bigint      not null,
    checkin_interval     bigint      not null,
    primary key (sched_name, instance_name)
);

-- ----------------------------
-- 10、 存储程序的悲观锁的信息(假如使用了悲观锁)
-- ---------------------------- 
create table QRTZ_LOCKS (
    sched_name           varchar(120)    not null,
    lock_name            varchar(40)     not null,
    primary key (sched_name, lock_name)
);

-- ----------------------------
-- 11、 Quartz集群实现同步机制的行锁表
-- ---------------------------- 
create table QRTZ_SIMPROP_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    str_prop_1           varchar(512)    null,
    str_prop_2           varchar(512)    null,
    str_prop_3           varchar(512)    null,
    int_prop_1           int             null,
    int_prop_2           int             null,
    long_prop_1          bigint          null,
    long_prop_2          bigint          null,
    dec_prop_1           numeric(13,4)   null,
    dec_prop_2           numeric(13,4)   null,
    bool_prop_1          varchar(1)      null,
    bool_prop_2          varchar(1)      null,
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
);

insert into sys_menu values('2000', '基础数据', '0', '5', 'mom/base', null, '', '', 1, 0, 'M', '0', '0', '', 'build', 'admin', CURRENT_TIMESTAMP(), '', null, 'MOM基础数据目录');
insert into sys_menu values('2001', '物料数据', '2000', '1', 'material', 'mom/base/material/index', '', '', 1, 0, 'C', '0', '0', 'mom:base:material:list', 'component', 'admin', CURRENT_TIMESTAMP(), '', null, '物料数据菜单');
insert into sys_menu values('2007', '物料分类', '2000', '2', 'materialCategory', 'mom/base/materialCategory/index', '', '', 1, 0, 'C', '0', '0', 'mom:base:materialCategory:list', 'tree', 'admin', CURRENT_TIMESTAMP(), '', null, '物料分类菜单');
insert into sys_menu values('2003', '生产资源', '2000', '3', 'resource', 'mom/base/resource/index', '', '', 1, 0, 'C', '0', '0', 'mom:base:resource:list', 'tree', 'admin', CURRENT_TIMESTAMP(), '', null, '生产资源菜单');
insert into sys_menu values('2004', '班次日历', '2000', '4', 'calendar', 'mom/base/calendar/index', '', '', 1, 0, 'C', '0', '0', 'mom:base:calendar:list', 'date-range', 'admin', CURRENT_TIMESTAMP(), '', null, '班次日历菜单');
insert into sys_menu values('2005', '工艺路线', '2000', '5', 'routing', 'mom/base/routing/index', '', '', 1, 0, 'C', '0', '0', 'mom:base:routing:list', 'tree-table', 'admin', CURRENT_TIMESTAMP(), '', null, '工艺路线菜单');
insert into sys_menu values('2006', '工序/工步维护', '2000', '6', 'operation', 'mom/base/operation/index', '', '', 1, 0, 'C', '0', '0', 'mom:base:operation:list', 'list', 'admin', CURRENT_TIMESTAMP(), '', null, '工序工步维护菜单');
insert into sys_menu values('2200', 'MBOM管理', '0', '6', 'mom/mbom', null, '', '', 1, 0, 'M', '0', '0', '', 'tree-table', 'admin', CURRENT_TIMESTAMP(), '', null, 'MBOM管理目录');
insert into sys_menu values('2201', 'MBOM维护', '2200', '1', 'index', 'mom/mbom/index', '', '', 1, 0, 'C', '0', '0', 'mom:mbom:list', 'tree-table', 'admin', CURRENT_TIMESTAMP(), '', null, 'MBOM维护菜单');
insert into sys_menu values('2300', '生产管理', '0', '7', 'mom/production', null, '', '', 1, 0, 'M', '0', '0', '', 'form', 'admin', CURRENT_TIMESTAMP(), '', null, '生产管理目录');
insert into sys_menu values('2301', '生产工单', '2300', '1', 'workorder', 'mom/production/workorder/index', '', '', 1, 0, 'C', '0', '0', 'mom:workorder:list', 'form', 'admin', CURRENT_TIMESTAMP(), '', null, '生产工单菜单');
insert into sys_menu values('2302', '生产排产', '2300', '2', 'schedule', 'mom/production/schedule/index', '', '', 1, 0, 'C', '0', '0', 'mom:schedule:list', 'date-range', 'admin', CURRENT_TIMESTAMP(), '', null, '生产排产菜单');
insert into sys_menu values('2303', '工步报工', '2300', '3', 'report', 'mom/production/report/index', '', '', 1, 0, 'C', '0', '0', 'mom:report:list', 'edit', 'admin', CURRENT_TIMESTAMP(), '', null, '工步报工菜单');
insert into sys_menu values('2304', '形迹托盘', '2300', '4', 'tray', 'mom/production/tray/index', '', '', 1, 0, 'C', '0', '0', 'mom:tray:list', 'tree', 'admin', CURRENT_TIMESTAMP(), '', null, '形迹托盘菜单');
insert into sys_menu values('2400', '设备管理', '0', '8', 'mom/device', null, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', CURRENT_TIMESTAMP(), '', null, 'MOM设备管理目录');
insert into sys_menu values('2401', '设备信息', '2400', '1', 'index', 'mom/device/index', '', '', 1, 0, 'C', '0', '0', 'mom:device:list', 'server', 'admin', CURRENT_TIMESTAMP(), '', null, '设备信息菜单');
insert into sys_menu values('2500', '数据追溯', '0', '9', 'mom/trace', null, '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', CURRENT_TIMESTAMP(), '', null, 'MOM数据追溯目录');
insert into sys_menu values('2501', '上下岗日志', '2500', '1', 'duty', 'mom/trace/duty/index', '', '', 1, 0, 'C', '0', '0', 'mom:trace:list', 'user', 'admin', CURRENT_TIMESTAMP(), '', null, '上下岗日志菜单');
insert into sys_menu values('2502', '生产信息追溯', '2500', '2', 'production', 'mom/trace/production/index', '', '', 1, 0, 'C', '0', '0', 'mom:trace:list', 'documentation', 'admin', CURRENT_TIMESTAMP(), '', null, '生产追溯菜单');
insert into sys_menu values('2600', '三维页面', '0', '10', 'mom/three', 'mom/three/index', '', '', 1, 0, 'C', '0', '0', 'mom:three:view', 'international', 'admin', CURRENT_TIMESTAMP(), '', null, '三维页面入口');
insert into sys_menu values('2101', '物料查询', '2001', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:material:query', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2102', '物料新增', '2001', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:material:add', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2103', '物料修改', '2001', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:material:edit', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2104', '物料删除', '2001', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:material:remove', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2105', '物料导出', '2001', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:material:export', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2106', '物料导入', '2001', '6', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:material:import', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2161', '分类查询', '2007', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:materialCategory:query', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2162', '分类新增', '2007', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:materialCategory:add', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2163', '分类修改', '2007', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:materialCategory:edit', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2164', '分类删除', '2007', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:materialCategory:remove', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2121', '资源查询', '2003', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:resource:query', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2122', '资源新增', '2003', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:resource:add', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2123', '资源修改', '2003', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:resource:edit', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2124', '资源删除', '2003', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:resource:remove', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2125', '资源导出', '2003', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:resource:export', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2131', '日历查询', '2004', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:calendar:query', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2132', '日历新增', '2004', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:calendar:add', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2133', '日历修改', '2004', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:calendar:edit', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2134', '日历删除', '2004', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:calendar:remove', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2135', '日历导出', '2004', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:calendar:export', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2141', '路线查询', '2005', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:routing:query', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2142', '路线新增', '2005', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:routing:add', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2143', '路线修改', '2005', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:routing:edit', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2144', '路线删除', '2005', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:routing:remove', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2145', '路线导出', '2005', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:routing:export', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2151', '工序查询', '2006', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:operation:query', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2152', '工序新增', '2006', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:operation:add', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2153', '工序修改', '2006', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:operation:edit', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2154', '工序删除', '2006', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:operation:remove', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2155', '工序导出', '2006', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:operation:export', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2161', '工步查询', '2006', '6', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:step:query', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2162', '工步新增', '2006', '7', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:step:add', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2163', '工步修改', '2006', '8', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:step:edit', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2164', '工步删除', '2006', '9', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:step:remove', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2165', '工步导出', '2006', '10', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:step:export', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2211', 'MBOM查询', '2201', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:query', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2212', 'MBOM新增', '2201', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:add', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2213', 'MBOM修改', '2201', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:edit', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2214', 'MBOM删除', '2201', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:remove', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2215', 'MBOM导出', '2201', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:export', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2216', 'PBOM维护', '2200', '2', 'pbom', 'mom/pbom/index', '', '', 1, 0, 'C', '0', '0', 'mom:pbom:list', 'tree-table', 'admin', CURRENT_TIMESTAMP(), '', null, 'PBOM维护菜单');
insert into sys_menu values('2231', 'PBOM查询', '2216', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:pbom:query', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2232', 'PBOM新增', '2216', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:pbom:add', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2233', 'PBOM修改', '2216', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:pbom:edit', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2234', 'PBOM删除', '2216', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:pbom:remove', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2235', 'PBOM导出', '2216', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:pbom:export', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2221', '明细查询', '2201', '6', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:item:query', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2222', '明细新增', '2201', '7', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:item:add', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2223', '明细修改', '2201', '8', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:item:edit', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2224', '明细删除', '2201', '9', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:item:remove', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2225', '明细导出', '2201', '10', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:item:export', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2311', '工单查询', '2301', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workorder:query', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2312', '工单新增', '2301', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workorder:add', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2313', '工单修改', '2301', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workorder:edit', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2314', '工单删除', '2301', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workorder:remove', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2315', '工单导出', '2301', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workorder:export', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2316', '工单下达', '2301', '6', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workorder:release', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2317', '工单开工', '2301', '7', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workorder:start', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2318', '工单完工', '2301', '8', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workorder:finish', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2319', '工单关闭', '2301', '9', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workorder:close', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2321', '排产查询', '2302', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:schedule:query', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2322', '排产新增', '2302', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:schedule:add', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2323', '排产修改', '2302', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:schedule:edit', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2324', '排产删除', '2302', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:schedule:remove', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2325', '排产导出', '2302', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:schedule:export', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2326', '排产下达', '2302', '6', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:schedule:release', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2327', '排产开工', '2302', '7', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:schedule:start', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2328', '排产完工', '2302', '8', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:schedule:finish', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2329', '排产取消', '2302', '9', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:schedule:cancel', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2331', '报工查询', '2303', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:report:query', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2332', '报工新增', '2303', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:report:add', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2333', '报工删除', '2303', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:report:remove', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2334', '报工导出', '2303', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:report:export', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2341', '托盘查询', '2304', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:tray:query', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2342', '托盘新增', '2304', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:tray:add', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2343', '托盘修改', '2304', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:tray:edit', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2344', '托盘删除', '2304', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:tray:remove', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2351', '设备查询', '2401', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:device:query', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2352', '设备新增', '2401', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:device:add', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2353', '设备修改', '2401', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:device:edit', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2354', '设备删除', '2401', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:device:remove', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2355', '设备操作', '2401', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:device:operate', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2361', '操作台任务', '2300', '10', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workstation:list', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2362', '操作台查询', '2300', '11', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workstation:query', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2363', '操作台操作', '2300', '12', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workstation:edit', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');
insert into sys_menu values('2371', '追溯查询', '2500', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:trace:query', '#', 'admin', CURRENT_TIMESTAMP(), '', null, '');

insert into sys_dict_type values(200, '物料类型', 'mom_material_type', '0', 'admin', CURRENT_TIMESTAMP(), '', null, 'MOM物料类型');
insert into sys_dict_type values(201, '资源类型', 'mom_resource_type', '0', 'admin', CURRENT_TIMESTAMP(), '', null, 'MOM资源类型');
insert into sys_dict_type values(202, '是否选项', 'mom_yes_no', '0', 'admin', CURRENT_TIMESTAMP(), '', null, 'MOM是否选项');
insert into sys_dict_type values(203, '投料方式', 'mom_issue_type', '0', 'admin', CURRENT_TIMESTAMP(), '', null, 'MOM投料方式');
insert into sys_dict_type values(204, '工单状态', 'mom_work_order_status', '0', 'admin', CURRENT_TIMESTAMP(), '', null, 'MOM工单状态');
insert into sys_dict_type values(205, '工单优先级', 'mom_work_order_priority', '0', 'admin', CURRENT_TIMESTAMP(), '', null, 'MOM工单优先级');
insert into sys_dict_type values(206, '排产状态', 'mom_schedule_status', '0', 'admin', CURRENT_TIMESTAMP(), '', null, 'MOM排产状态');
insert into sys_dict_type values(207, '报工状态', 'mom_report_status', '0', 'admin', CURRENT_TIMESTAMP(), '', null, 'MOM报工状态');
insert into sys_dict_data values(2000, 1, '原材料', 'raw', 'mom_material_type', '', 'primary', 'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '原材料');
insert into sys_dict_data values(2001, 2, '半成品', 'semi', 'mom_material_type', '', 'info', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '半成品');
insert into sys_dict_data values(2002, 3, '成品', 'product', 'mom_material_type', '', 'success', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '成品');
insert into sys_dict_data values(2003, 4, '辅料', 'aux', 'mom_material_type', '', 'warning', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '辅料');
insert into sys_dict_data values(2009, 0, '工厂', 'factory', 'mom_resource_type', '', 'primary', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '工厂');
insert into sys_dict_data values(2010, 1, '车间', 'workshop', 'mom_resource_type', '', 'primary', 'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '车间');
insert into sys_dict_data values(2011, 2, '产线', 'line', 'mom_resource_type', '', 'success', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '产线');
insert into sys_dict_data values(2012, 3, '工位', 'station', 'mom_resource_type', '', 'warning', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '工位');
insert into sys_dict_data values(2013, 4, '设备', 'equipment', 'mom_resource_type', '', 'info', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '设备');
insert into sys_dict_data values(2014, 5, '库位', 'location', 'mom_resource_type', '', 'default', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '库位');
insert into sys_dict_data values(2020, 1, '是', 'Y', 'mom_yes_no', '', 'primary', 'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '是');
insert into sys_dict_data values(2021, 2, '否', 'N', 'mom_yes_no', '', 'danger', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '否');
insert into sys_dict_data values(2030, 1, '按单领料', 'order', 'mom_issue_type', '', 'primary', 'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '按单领料');
insert into sys_dict_data values(2031, 2, '工序投料', 'operation', 'mom_issue_type', '', 'success', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '工序投料');
insert into sys_dict_data values(2032, 3, '倒冲扣料', 'backflush', 'mom_issue_type', '', 'warning', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '倒冲扣料');
insert into sys_dict_data values(2040, 1, '草稿', 'draft', 'mom_work_order_status', '', 'info', 'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '草稿');
insert into sys_dict_data values(2041, 2, '已下达', 'released', 'mom_work_order_status', '', 'primary', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '已下达');
insert into sys_dict_data values(2042, 3, '生产中', 'running', 'mom_work_order_status', '', 'warning', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '生产中');
insert into sys_dict_data values(2043, 4, '已完工', 'finished', 'mom_work_order_status', '', 'success', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '已完工');
insert into sys_dict_data values(2044, 5, '已关闭', 'closed', 'mom_work_order_status', '', 'danger', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '已关闭');
insert into sys_dict_data values(2050, 1, '普通', 'normal', 'mom_work_order_priority', '', 'info', 'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '普通');
insert into sys_dict_data values(2051, 2, '加急', 'urgent', 'mom_work_order_priority', '', 'warning', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '加急');
insert into sys_dict_data values(2052, 3, '紧急', 'critical', 'mom_work_order_priority', '', 'danger', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '紧急');
insert into sys_dict_data values(2060, 1, '草稿', 'draft', 'mom_schedule_status', '', 'info', 'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '草稿');
insert into sys_dict_data values(2061, 2, '已下达', 'released', 'mom_schedule_status', '', 'primary', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '已下达');
insert into sys_dict_data values(2062, 3, '生产中', 'running', 'mom_schedule_status', '', 'warning', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '生产中');
insert into sys_dict_data values(2063, 4, '已完工', 'finished', 'mom_schedule_status', '', 'success', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '已完工');
insert into sys_dict_data values(2064, 5, '已取消', 'cancelled', 'mom_schedule_status', '', 'danger', 'N', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '已取消');
insert into sys_dict_data values(2070, 1, '已确认', 'confirmed', 'mom_report_status', '', 'success', 'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '已确认');

drop table if exists mom_step_report;
drop table if exists mom_production_trace;
drop table if exists mom_duty_log;
drop table if exists mom_material_binding;
drop table if exists mom_device;
drop table if exists mom_device_category;
drop table if exists mom_tray_item;
drop table if exists mom_tray;
drop table if exists mom_pbom_item;
drop table if exists mom_pbom;
drop table if exists mom_schedule;
drop table if exists mom_work_order;
drop table if exists mom_mbom_item;
drop table if exists mom_mbom;
drop table if exists mom_work_step;
drop table if exists mom_operation;
drop table if exists mom_routing;
drop table if exists mom_shift_calendar;
drop table if exists mom_resource;
drop table if exists mom_product;
drop table if exists mom_material;
drop table if exists mom_material_category;
create table mom_material_category (
  category_id bigint not null auto_increment,
  parent_id bigint default 0,
  ancestors varchar(50) default '',
  category_code varchar(64) not null,
  category_name varchar(100) not null,
  order_num int default 0,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (category_id),
  constraint uk_mom_material_category_code unique (category_code)
);
create table mom_material (
  material_id bigint not null auto_increment,
  material_code varchar(64) not null,
  material_name varchar(100) not null,
  spec_model varchar(100) default null,
  unit varchar(32) default null,
  category_id bigint default null,
  material_type varchar(32) default null,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (material_id),
  constraint uk_mom_material_code unique (material_code)
);
create table mom_product (
  product_id bigint not null auto_increment,
  product_code varchar(64) not null,
  product_name varchar(100) not null,
  material_id bigint default null,
  spec_model varchar(100) default null,
  unit varchar(32) default null,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (product_id),
  constraint uk_mom_product_code unique (product_code)
);
create table mom_resource (
  resource_id bigint not null auto_increment,
  resource_code varchar(64) not null,
  resource_name varchar(100) not null,
  resource_type varchar(32) default null,
  parent_id bigint default 0,
  workshop varchar(100) default null,
  line_code varchar(64) default null,
  status char(1) default '0',
  station_note_flag char(1) default 'N',
  print_box_flag char(1) default 'N',
  print_nameplate_flag char(1) default 'N',
  line_type varchar(32) default null,
  station_type varchar(32) default null,
  skill_require varchar(200) default null,
  wip_capacity int default 0,
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (resource_id),
  constraint uk_mom_resource_code unique (resource_code)
);
create table mom_shift_calendar (
  calendar_id bigint not null auto_increment,
  calendar_date date not null,
  shift_code varchar(64) not null,
  shift_name varchar(100) not null,
  start_time varchar(8) default null,
  end_time varchar(8) default null,
  is_workday char(1) default 'Y',
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (calendar_id),
  constraint uk_mom_calendar_shift unique (calendar_date, shift_code)
);
create table mom_routing (
  routing_id bigint not null auto_increment,
  routing_code varchar(64) not null,
  routing_name varchar(100) not null,
  product_id bigint not null,
  version varchar(32) not null,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (routing_id),
  constraint uk_mom_routing_code unique (routing_code),
  constraint uk_mom_routing_product_version unique (product_id, version)
);
create table mom_operation (
  operation_id bigint not null auto_increment,
  routing_id bigint not null,
  operation_code varchar(64) not null,
  operation_name varchar(100) not null,
  operation_seq int not null,
  standard_minutes decimal(10,2) default null,
  resource_type varchar(32) default null,
  resource_id bigint default null,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (operation_id),
  constraint uk_mom_operation_seq unique (routing_id, operation_seq)
);
create table mom_work_step (
  step_id bigint not null auto_increment,
  operation_id bigint not null,
  step_code varchar(64) not null,
  step_name varchar(100) not null,
  step_seq int not null,
  standard_minutes decimal(10,2) default null,
  is_report_point char(1) default 'Y',
  step_desc varchar(1000) default null,
  operation_type varchar(32) default null,
  screw_check_count int default 0,
  vision_program varchar(100) default null,
  guide_task_id varchar(100) default null,
  image_url varchar(500) default null,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (step_id),
  constraint uk_mom_step_seq unique (operation_id, step_seq)
);
create table mom_pbom (
  pbom_id bigint not null auto_increment,
  pbom_code varchar(64) not null,
  pbom_name varchar(100) not null,
  product_id bigint not null,
  version varchar(32) default 'V1',
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (pbom_id),
  constraint uk_mom_pbom_code unique (pbom_code)
);
create table mom_pbom_item (
  item_id bigint not null auto_increment,
  pbom_id bigint not null,
  parent_item_id bigint default 0,
  material_id bigint not null,
  resource_id bigint default null,
  item_seq int not null,
  quantity decimal(18,6) default 1,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (item_id)
);
create table mom_mbom (
  mbom_id bigint not null auto_increment,
  mbom_code varchar(64) not null,
  mbom_name varchar(100) not null,
  product_id bigint not null,
  version varchar(32) not null,
  effective_date date default null,
  expire_date date default null,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (mbom_id),
  constraint uk_mom_mbom_code unique (mbom_code),
  constraint uk_mom_mbom_product_version unique (product_id, version)
);
create table mom_mbom_item (
  item_id bigint not null auto_increment,
  mbom_id bigint not null,
  parent_item_id bigint default 0,
  material_id bigint not null,
  item_seq int not null,
  quantity decimal(18,6) not null,
  scrap_rate decimal(8,4) default 0,
  operation_id bigint default null,
  step_id bigint default null,
  issue_type varchar(32) default null,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (item_id),
  constraint uk_mom_mbom_item_seq unique (mbom_id, parent_item_id, item_seq)
);
create table mom_work_order (
  work_order_id bigint not null auto_increment,
  work_order_code varchar(64) not null,
  work_order_name varchar(100) not null,
  product_id bigint not null,
  mbom_id bigint default null,
  routing_id bigint default null,
  resource_id bigint default null,
  plan_qty decimal(18,6) not null,
  completed_qty decimal(18,6) default 0,
  unit varchar(32) default null,
  priority varchar(32) default 'normal',
  source_order_code varchar(64) default null,
  plan_start_date date default null,
  plan_end_date date default null,
  actual_start_time timestamp,
  actual_end_time timestamp,
  status varchar(32) default 'draft',
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (work_order_id),
  constraint uk_mom_work_order_code unique (work_order_code)
);
create table mom_schedule (
  schedule_id bigint not null auto_increment,
  schedule_code varchar(64) not null,
  work_order_id bigint not null,
  operation_id bigint default null,
  resource_id bigint not null,
  plan_start_time timestamp not null,
  plan_end_time timestamp not null,
  plan_qty decimal(18,6) not null,
  reported_qty decimal(18,6) default 0,
  status varchar(32) default 'draft',
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (schedule_id),
  constraint uk_mom_schedule_code unique (schedule_code)
);
create table mom_step_report (
  report_id bigint not null auto_increment,
  work_order_id bigint not null,
  schedule_id bigint default null,
  operation_id bigint not null,
  step_id bigint not null,
  resource_id bigint default null,
  good_qty decimal(18,6) not null,
  bad_qty decimal(18,6) default 0,
  report_time timestamp,
  report_user varchar(64) default '',
  status varchar(32) default 'confirmed',
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (report_id)
);
create table mom_tray (
  tray_id bigint not null auto_increment,
  tray_code varchar(64) not null,
  tray_name varchar(100) default null,
  tray_type varchar(32) default 'shape',
  resource_id bigint default null,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (tray_id),
  constraint uk_mom_tray_code unique (tray_code)
);
create table mom_tray_item (
  item_id bigint not null auto_increment,
  tray_id bigint not null,
  material_id bigint not null,
  location_code varchar(64) default null,
  quantity decimal(18,6) default 1,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (item_id)
);
create table mom_device_category (
  category_id bigint not null auto_increment,
  category_code varchar(64) not null,
  category_name varchar(100) not null,
  device_type varchar(32) not null,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (category_id),
  constraint uk_mom_device_category_code unique (category_code)
);
create table mom_device (
  device_id bigint not null auto_increment,
  device_code varchar(64) not null,
  device_name varchar(100) not null,
  category_id bigint default null,
  resource_id bigint default null,
  ip_address varchar(64) default null,
  port int default null,
  status varchar(32) default 'offline',
  runtime_data varchar(1000) default null,
  last_connect_time timestamp,
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (device_id),
  constraint uk_mom_device_code unique (device_code)
);
create table mom_material_binding (
  binding_id bigint not null auto_increment,
  schedule_id bigint not null,
  material_id bigint not null,
  resource_id bigint default null,
  box_code varchar(64) not null,
  binding_type varchar(32) default 'box',
  quantity decimal(18,6) default 1,
  status varchar(32) default 'bound',
  create_by varchar(64) default '',
  create_time timestamp,
  update_by varchar(64) default '',
  update_time timestamp,
  remark varchar(500) default null,
  primary key (binding_id)
);
create table mom_duty_log (
  log_id bigint not null auto_increment,
  user_name varchar(64) default '',
  rfid_card varchar(64) default null,
  resource_id bigint default null,
  duty_type varchar(32) default 'operator',
  status varchar(32) default 'on',
  create_by varchar(64) default '',
  create_time timestamp,
  remark varchar(500) default null,
  primary key (log_id)
);
create table mom_production_trace (
  trace_id bigint not null auto_increment,
  work_order_id bigint default null,
  schedule_id bigint default null,
  operation_id bigint default null,
  step_id bigint default null,
  resource_id bigint default null,
  material_id bigint default null,
  device_id bigint default null,
  serial_no varchar(100) default null,
  trace_type varchar(32) default null,
  event_name varchar(100) default null,
  operator_name varchar(64) default null,
  result varchar(32) default null,
  event_data varchar(1000) default null,
  create_by varchar(64) default '',
  create_time timestamp,
  remark varchar(500) default null,
  primary key (trace_id)
);

insert into mom_material_category values(1, 0, '0', 'RAW', '原材料', 1, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '原材料分类');
insert into mom_material_category values(2, 0, '0', 'AUX', '辅料', 2, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '辅料分类');
insert into mom_material_category values(3, 0, '0', 'SEMI', '半成品', 3, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '半成品分类');
insert into mom_material_category values(4, 0, '0', 'FG', '成品', 4, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '成品分类');

insert into mom_material values(1, 'MAT-RAW-001', '铝型材坯料', '6061-T6 40x40', '根', 1, 'raw', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试原材料');
insert into mom_material values(2, 'MAT-RAW-002', '紧固件套包', 'M6标准套包', '套', 2, 'aux', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试辅料');
insert into mom_material values(3, 'MAT-SEMI-001', '装配半成品A', 'ASM-A', '件', 3, 'semi', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试半成品');
insert into mom_material values(4, 'MAT-FG-001', '智能控制箱', 'ICB-100', '台', 4, 'product', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试成品');
insert into mom_material values(5, 'MAT-FG-002', '标准驱动模块', 'DRV-200', '台', 4, 'product', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试成品');

insert into mom_product values(1, 'PRD-ICB-100', '智能控制箱', 4, 'ICB-100', '台', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '关联成品物料');
insert into mom_product values(2, 'PRD-DRV-200', '标准驱动模块', 5, 'DRV-200', '台', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '关联成品物料');

insert into mom_resource(resource_id, resource_code, resource_name, resource_type, parent_id, workshop, line_code, status, station_note_flag, print_box_flag, print_nameplate_flag, line_type, station_type, skill_require, wip_capacity, create_by, create_time, update_by, update_time, remark) values(1, 'FAC-HZ', '杭州工厂', 'factory', 0, null, null, '0', 'N', 'N', 'N', null, null, null, 0, 'admin', CURRENT_TIMESTAMP(), '', null, '测试工厂');
insert into mom_resource(resource_id, resource_code, resource_name, resource_type, parent_id, workshop, line_code, status, station_note_flag, print_box_flag, print_nameplate_flag, line_type, station_type, skill_require, wip_capacity, create_by, create_time, update_by, update_time, remark) values(2, 'WS-01', '1号车间', 'workshop', 1, '1号车间', null, '0', 'N', 'N', 'N', null, null, null, 0, 'admin', CURRENT_TIMESTAMP(), '', null, '测试车间');
insert into mom_resource(resource_id, resource_code, resource_name, resource_type, parent_id, workshop, line_code, status, station_note_flag, print_box_flag, print_nameplate_flag, line_type, station_type, skill_require, wip_capacity, create_by, create_time, update_by, update_time, remark) values(3, 'L1', 'L1', 'line', 2, '1号车间', 'L1', '0', 'N', 'N', 'N', 'main', null, null, 0, 'admin', CURRENT_TIMESTAMP(), '', null, '测试产线');
insert into mom_resource(resource_id, resource_code, resource_name, resource_type, parent_id, workshop, line_code, status, station_note_flag, print_box_flag, print_nameplate_flag, line_type, station_type, skill_require, wip_capacity, create_by, create_time, update_by, update_time, remark) values(4, 'OP190-L1', 'OP190-L1', 'station', 3, '1号车间', 'L1', '0', 'N', 'N', 'N', 'main', null, null, 5, 'admin', CURRENT_TIMESTAMP(), '', null, '测试工位');
insert into mom_resource(resource_id, resource_code, resource_name, resource_type, parent_id, workshop, line_code, status, station_note_flag, print_box_flag, print_nameplate_flag, line_type, station_type, skill_require, wip_capacity, create_by, create_time, update_by, update_time, remark) values(5, 'OP180-L1', 'OP180-L1', 'station', 3, '1号车间', 'L1', '0', 'N', 'N', 'N', 'main', null, null, 5, 'admin', CURRENT_TIMESTAMP(), '', null, '测试工位');
insert into mom_resource(resource_id, resource_code, resource_name, resource_type, parent_id, workshop, line_code, status, station_note_flag, print_box_flag, print_nameplate_flag, line_type, station_type, skill_require, wip_capacity, create_by, create_time, update_by, update_time, remark) values(6, 'BIN-OP190-01', 'OP190库位01', 'location', 4, '1号车间', 'L1', '0', 'N', 'N', 'N', null, null, null, 0, 'admin', CURRENT_TIMESTAMP(), '', null, '工位库位');
insert into mom_resource(resource_id, resource_code, resource_name, resource_type, parent_id, workshop, line_code, status, station_note_flag, print_box_flag, print_nameplate_flag, line_type, station_type, skill_require, wip_capacity, create_by, create_time, update_by, update_time, remark) values(7, 'BIN-OP190-02', 'OP190库位02', 'location', 4, '1号车间', 'L1', '0', 'N', 'N', 'N', null, null, null, 0, 'admin', CURRENT_TIMESTAMP(), '', null, '工位库位');

insert into mom_shift_calendar values(1, '2026-06-08', 'DAY', '白班', '08:00', '17:00', 'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试班次');
insert into mom_shift_calendar values(2, '2026-06-08', 'NIGHT', '夜班', '20:00', '05:00', 'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试班次');
insert into mom_shift_calendar values(3, '2026-06-09', 'DAY', '白班', '08:00', '17:00', 'Y', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试班次');

insert into mom_routing values(1, 'RT-ICB-100-V1', '智能控制箱标准路线', 4, 'V1', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试工艺路线');
insert into mom_routing values(2, 'RT-DRV-200-V1', '标准驱动模块路线', 5, 'V1', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试工艺路线');

insert into mom_operation values(1, 1, 'OP-010', '备料', 10, 15.00, 'station', 4, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试工序');
insert into mom_operation values(2, 1, 'OP-020', '主体装配', 20, 35.00, 'station', 5, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试工序');
insert into mom_operation values(3, 1, 'OP-030', '电气测试', 30, 20.00, 'station', 4, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试工序');
insert into mom_operation values(4, 2, 'OP-010', '模块装配', 10, 25.00, 'station', 5, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试工序');
insert into mom_operation values(5, 2, 'OP-020', '包装入库', 20, 10.00, 'station', 4, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试工序');

insert into mom_work_step values(1, 1, 'STEP-010', '领取铝型材坯料', 10, 5.00, 'Y', '扫描料盒码，确认铝型材坯料规格和数量。', 'prepare', 0, null, 'GUIDE-010', 'http://192.168.0.100:4060/images/esop-step-010.jpg', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试工步');
insert into mom_work_step values(2, 1, 'STEP-020', '核对紧固件套包', 20, 5.00, 'N', '核对紧固件套包标签，放入二号料盒位。', 'prepare', 0, null, 'GUIDE-020', 'http://192.168.0.100:4060/images/esop-step-020.jpg', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试工步');
insert into mom_work_step values(3, 2, 'STEP-010', '安装控制箱主体', 10, 20.00, 'Y', '按照 ESOP 图片安装控制箱主体，完成后按完工报时。', 'assemble', 0, null, 'GUIDE-030', 'http://192.168.0.100:4060/images/esop-step-030.jpg', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试工步');
insert into mom_work_step values(4, 2, 'STEP-020', '锁附紧固件', 20, 15.00, 'Y', '按激光指引锁附紧固件，电批 OK 后自动进入下一步。', 'screw', 4, 'HK-VISION-001', 'GUIDE-040', 'http://192.168.0.100:4060/images/esop-step-040.jpg', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试工步');
insert into mom_work_step values(5, 3, 'STEP-010', '通电测试', 10, 10.00, 'Y', '接入电测台并读取测试结果。', 'test', 0, null, 'GUIDE-050', 'http://192.168.0.100:4060/images/esop-step-050.jpg', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试工步');
insert into mom_work_step values(6, 3, 'STEP-020', '记录测试结果', 20, 10.00, 'Y', '拍照留存并记录测试数据。', 'camera', 0, 'HK-CAPTURE-001', 'GUIDE-060', 'http://192.168.0.100:4060/images/esop-step-060.jpg', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试工步');
insert into mom_work_step values(7, 4, 'STEP-010', '模块预装', 10, 15.00, 'Y', '将驱动模块预装到位。', 'assemble', 0, null, 'GUIDE-070', 'http://192.168.0.100:4060/images/esop-step-070.jpg', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试工步');
insert into mom_work_step values(8, 4, 'STEP-020', '外观检查', 20, 10.00, 'Y', '使用 2D 相机拍照并检查外观。', 'camera', 0, 'HK-CAPTURE-002', 'GUIDE-080', 'http://192.168.0.100:4060/images/esop-step-080.jpg', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试工步');
insert into mom_work_step values(9, 5, 'STEP-010', '贴标包装', 10, 10.00, 'Y', '贴标后完成包装入库。', 'pack', 0, null, 'GUIDE-090', 'http://192.168.0.100:4060/images/esop-step-090.jpg', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试工步');

insert into mom_mbom values(1, 'MBOM-ICB-100-V1', '智能控制箱制造BOM', 4, 'V1', '2026-06-08', null, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试MBOM');
insert into mom_mbom values(2, 'MBOM-DRV-200-V1', '标准驱动模块制造BOM', 5, 'V1', '2026-06-08', null, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试MBOM');
insert into mom_mbom_item values(1, 1, 0, 3, 10, 1.000000, 0.0000, 2, 3, 'operation', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '半成品投入');
insert into mom_mbom_item values(2, 1, 1, 1, 10, 2.000000, 0.0200, 1, 1, 'order', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '半成品子项');
insert into mom_mbom_item values(3, 1, 1, 2, 20, 1.000000, 0.0100, 2, 4, 'operation', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '半成品子项');
insert into mom_mbom_item values(4, 1, 0, 2, 20, 1.000000, 0.0100, 3, 5, 'backflush', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试投料');
insert into mom_mbom_item values(5, 2, 0, 1, 10, 1.000000, 0.0100, 4, 7, 'operation', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '模块用料');
insert into mom_mbom_item values(6, 2, 0, 2, 20, 1.000000, 0.0000, 5, 9, 'backflush', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '包装用料');
insert into mom_work_order values(1, 'WO-20260608-001', '智能控制箱试制工单', 4, 1, 1, 2, 50.000000, 0.000000, '台', 'urgent', 'SO-TEST-001', '2026-06-08', '2026-06-10', null, null, 'released', 'admin', CURRENT_TIMESTAMP(), '', null, '测试已下达工单');
insert into mom_work_order values(2, 'WO-20260608-002', '标准驱动模块生产工单', 5, 2, 2, 2, 100.000000, 35.000000, '台', 'normal', 'SO-TEST-002', '2026-06-09', '2026-06-12', CURRENT_TIMESTAMP(), null, 'running', 'admin', CURRENT_TIMESTAMP(), '', null, '测试生产中工单');
insert into mom_work_order values(3, 'WO-20260608-003', '智能控制箱草稿工单', 4, 1, 1, 3, 20.000000, 0.000000, '台', 'normal', null, '2026-06-13', '2026-06-14', null, null, 'draft', 'admin', CURRENT_TIMESTAMP(), '', null, '测试草稿工单');
insert into mom_schedule values(1, 'SCH-20260608-001', 1, 2, 3, '2026-06-08 08:00:00', '2026-06-08 12:00:00', 50.000000, 0.000000, 'released', 'admin', CURRENT_TIMESTAMP(), '', null, '智能控制箱主体装配排产');
insert into mom_schedule values(2, 'SCH-20260609-001', 2, 4, 3, '2026-06-09 08:00:00', '2026-06-09 13:00:00', 100.000000, 35.000000, 'running', 'admin', CURRENT_TIMESTAMP(), '', null, '标准驱动模块装配排产');
insert into mom_schedule values(3, 'SCH-20260613-001', 3, 2, 4, '2026-06-13 08:00:00', '2026-06-13 11:00:00', 20.000000, 0.000000, 'draft', 'admin', CURRENT_TIMESTAMP(), '', null, '草稿工单测试排产');
insert into mom_step_report values(1, 2, 2, 4, 7, 3, 35.000000, 1.000000, CURRENT_TIMESTAMP(), 'admin', 'confirmed', 'admin', CURRENT_TIMESTAMP(), '', null, '测试报工记录');

insert into mom_pbom values(1, 'PBOM-ICB-100-V1', '智能控制箱设计BOM', 4, 'V1', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试PBOM');
insert into mom_pbom_item values(1, 1, 0, 1, 4, 10, 2.000000, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '铝型材坯料');
insert into mom_pbom_item values(2, 1, 0, 2, 4, 20, 1.000000, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '紧固件套包');
insert into mom_pbom_item values(3, 1, 0, 3, 5, 30, 1.000000, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '装配半成品A');

insert into mom_tray values(1, 'TRAY-A01-001', 'A01形迹托盘001', 'shape', 3, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '测试形迹托盘');
insert into mom_tray_item values(1, 1, 1, 'P01', 2.000000, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '托盘一号位');
insert into mom_tray_item values(2, 1, 2, 'P02', 1.000000, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '托盘二号位');

insert into mom_device_category values(1, 'CAMERA-2D', '2D摄像头', 'camera2d', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '拍照留存');
insert into mom_device_category values(2, 'SCREW-SUDONG', '速动电批', 'screwdriver', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '小力矩锁附');
insert into mom_device_category values(3, 'JBC-STATION', 'JBC焊台', 'jbc', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '焊接温控');
insert into mom_device_category values(4, 'CAMERA-3D', '3D相机', 'camera3d', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '三维检测');
insert into mom_device_category values(5, 'LASER-GUIDE', '激光指引', 'laser', '0', 'admin', CURRENT_TIMESTAMP(), '', null, '投射坐标');
insert into mom_device values(1, 'CAM-A01-01', 'A01工位2D相机', 1, 3, '192.168.0.21', 8000, 'online', '视频预览正常', CURRENT_TIMESTAMP(), 'admin', CURRENT_TIMESTAMP(), '', null, '测试相机');
insert into mom_device values(2, 'SD-A01-01', 'A01速动电批', 2, 3, '192.168.0.31', 502, 'online', 'OK 扭矩 1.25N.m', CURRENT_TIMESTAMP(), 'admin', CURRENT_TIMESTAMP(), '', null, '测试电批');
insert into mom_device values(3, 'JBC-A01-01', 'A01 JBC焊台', 3, 3, '192.168.0.41', 9001, 'offline', '温度 320℃', null, 'admin', CURRENT_TIMESTAMP(), '', null, '测试焊台');
insert into mom_device values(4, 'LASER-A01-01', 'A01激光指引', 5, 3, '192.168.0.51', 8088, 'online', 'X=120,Y=80', CURRENT_TIMESTAMP(), 'admin', CURRENT_TIMESTAMP(), '', null, '测试激光');

insert into mom_material_binding values(1, 1, 1, 6, 'BOX-A01-001', 'box', 2.000000, 'bound', 'admin', CURRENT_TIMESTAMP(), '', null, '测试料盒绑定');
insert into mom_material_binding values(2, 1, 2, 7, 'TRAY-A01-001', 'tray', 1.000000, 'bound', 'admin', CURRENT_TIMESTAMP(), '', null, '测试托盘绑定');
insert into mom_duty_log values(1, 'admin', 'RFID-ADMIN-001', 3, 'operator', 'on', 'admin', CURRENT_TIMESTAMP(), '测试上岗');
insert into mom_production_trace values(1, 2, 2, 4, 7, 3, null, null, 'SN-DRV-200-0001', 'report', '工步报工', 'admin', 'OK', '合格 35，不良 1', 'admin', CURRENT_TIMESTAMP(), '测试追溯');
insert into mom_production_trace values(2, 1, 1, null, null, 3, 1, null, 'SN-ICB-100-0001', 'prepare', '备料绑定', 'admin', 'OK', 'BOX-A01-001 已绑定铝型材坯料', 'admin', CURRENT_TIMESTAMP(), '测试追溯');

-- ----------------------------
-- 编码规则
-- ----------------------------
drop table if exists sys_code_rule_record;
drop table if exists sys_code_rule;
create table sys_code_rule (
  rule_id            bigint      not null auto_increment,
  rule_code          varchar(64)      not null,
  rule_name          varchar(100)     not null,
  prefix             varchar(32)      default '',
  date_format        varchar(32)      default 'yyyyMMdd',
  serial_length      int             not null default 4,
  separator          varchar(8)       default '-',
  reset_period       varchar(16)      not null default 'DAILY',
  current_serial     bigint          default 0,
  last_generate_time timestamp,
  status             char(1)         default '0',
  create_by          varchar(64)     default '',
  create_time        timestamp,
  update_by          varchar(64)     default '',
  update_time        timestamp,
  remark             varchar(500)    default null,
  primary key (rule_id),
  constraint uk_sys_code_rule_code unique (rule_code)
);

create table sys_code_rule_record (
  record_id          bigint      not null auto_increment,
  rule_code          varchar(64)      not null,
  generated_code     varchar(128)     not null,
  create_time        timestamp,
  primary key (record_id),
  constraint uk_sys_code_rule_record_code unique (rule_code, generated_code)
);

insert into sys_code_rule values(1, 'MATERIAL', '物料编码', 'MAT', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '物料数据编码规则');
insert into sys_code_rule values(2, 'RESOURCE', '资源编码', 'RES', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '生产资源编码规则');
insert into sys_code_rule values(3, 'WORK_ORDER', '工单编码', 'WO', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '生产工单编码规则');
insert into sys_code_rule values(4, 'FACTORY', '工厂编码', 'FAC', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '工厂自动编码规则');
insert into sys_code_rule values(5, 'WORKSHOP', '车间编码', 'WS', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '车间自动编码规则');
insert into sys_code_rule values(6, 'LINE', '产线编码', 'LINE', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '产线自动编码规则');
insert into sys_code_rule values(7, 'STATION', '工位编码', 'ST', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '工位自动编码规则');
insert into sys_code_rule values(8, 'LOCATION', '库位编码', 'LOC', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '库位自动编码规则');
insert into sys_code_rule values(9, 'ROUTING', '路线编码', 'RT', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '工艺路线自动编码规则');
insert into sys_code_rule values(10, 'OPERATION', '工序编码', 'OP', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '工序自动编码规则');
insert into sys_code_rule values(11, 'STEP', '工步编码', 'STEP', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', CURRENT_TIMESTAMP(), '', null, '工步自动编码规则');
insert into sys_code_rule values(12, 'PBOM', 'PBOM编码', 'PBOM', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', CURRENT_TIMESTAMP(), '', null, 'PBOM自动编码规则');

commit;
