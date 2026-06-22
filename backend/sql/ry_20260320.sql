-- ----------------------------
-- 1、部门表
-- ----------------------------
drop table if exists sys_dept;
create table sys_dept (
  dept_id           bigint(20)      not null auto_increment    comment '部门id',
  parent_id         bigint(20)      default 0                  comment '父部门id',
  ancestors         varchar(50)     default ''                 comment '祖级列表',
  dept_name         varchar(30)     default ''                 comment '部门名称',
  order_num         int(4)          default 0                  comment '显示顺序',
  leader            varchar(20)     default null               comment '负责人',
  phone             varchar(11)     default null               comment '联系电话',
  email             varchar(50)     default null               comment '邮箱',
  status            char(1)         default '0'                comment '部门状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (dept_id)
) engine=innodb auto_increment=200 comment = '部门表';

-- ----------------------------
-- 初始化-部门表数据
-- ----------------------------
insert into sys_dept values(100,  0,   '0',          '科技',   0, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(101,  100, '0,100',      '深圳总公司', 1, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(102,  100, '0,100',      '长沙分公司', 2, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(103,  101, '0,100,101',  '研发部门',   1, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(104,  101, '0,100,101',  '市场部门',   2, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(105,  101, '0,100,101',  '测试部门',   3, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(106,  101, '0,100,101',  '财务部门',   4, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(107,  101, '0,100,101',  '运维部门',   5, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(108,  102, '0,100,102',  '市场部门',   1, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(109,  102, '0,100,102',  '财务部门',   2, '', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);


-- ----------------------------
-- 2、用户信息表
-- ----------------------------
drop table if exists sys_user;
create table sys_user (
  user_id           bigint(20)      not null auto_increment    comment '用户ID',
  dept_id           bigint(20)      default null               comment '部门ID',
  user_name         varchar(30)     not null                   comment '用户账号',
  nick_name         varchar(30)     not null                   comment '用户昵称',
  user_type         varchar(2)      default '00'               comment '用户类型（00系统用户）',
  email             varchar(50)     default ''                 comment '用户邮箱',
  phonenumber       varchar(11)     default ''                 comment '手机号码',
  sex               char(1)         default '0'                comment '用户性别（0男 1女 2未知）',
  avatar            varchar(100)    default ''                 comment '头像地址',
  password          varchar(100)    default ''                 comment '密码',
  status            char(1)         default '0'                comment '账号状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  login_ip          varchar(128)    default ''                 comment '最后登录IP',
  login_date        datetime                                   comment '最后登录时间',
  pwd_update_date   datetime                                   comment '密码最后更新时间',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  rfid_card         varchar(64)     default null               comment 'RFID卡号',
  remark            varchar(500)    default null               comment '备注',
  primary key (user_id)
) engine=innodb auto_increment=100 comment = '用户信息表';

-- ----------------------------
-- 初始化-用户信息表数据
-- ----------------------------
insert into sys_user values(1,  103, 'admin', '', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, 'RFID-ADMIN-001', '管理员');
insert into sys_user values(2,  105, 'ry',    '', '00', 'ry@qq.com',  '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, 'RFID-OP-001', '测试员');


-- ----------------------------
-- 3、岗位信息表
-- ----------------------------
drop table if exists sys_post;
create table sys_post
(
  post_id       bigint(20)      not null auto_increment    comment '岗位ID',
  post_code     varchar(64)     not null                   comment '岗位编码',
  post_name     varchar(50)     not null                   comment '岗位名称',
  post_sort     int(4)          not null                   comment '显示顺序',
  status        char(1)         not null                   comment '状态（0正常 1停用）',
  create_by     varchar(64)     default ''                 comment '创建者',
  create_time   datetime                                   comment '创建时间',
  update_by     varchar(64)     default ''			       comment '更新者',
  update_time   datetime                                   comment '更新时间',
  remark        varchar(500)    default null               comment '备注',
  primary key (post_id)
) engine=innodb comment = '岗位信息表';

-- ----------------------------
-- 初始化-岗位信息表数据
-- ----------------------------
insert into sys_post values(1, 'ceo',  '董事长',    1, '0', 'admin', sysdate(), '', null, '');
insert into sys_post values(2, 'se',   '项目经理',  2, '0', 'admin', sysdate(), '', null, '');
insert into sys_post values(3, 'hr',   '人力资源',  3, '0', 'admin', sysdate(), '', null, '');
insert into sys_post values(4, 'user', '普通员工',  4, '0', 'admin', sysdate(), '', null, '');


-- ----------------------------
-- 4、角色信息表
-- ----------------------------
drop table if exists sys_role;
create table sys_role (
  role_id              bigint(20)      not null auto_increment    comment '角色ID',
  role_name            varchar(30)     not null                   comment '角色名称',
  role_key             varchar(100)    not null                   comment '角色权限字符串',
  role_sort            int(4)          not null                   comment '显示顺序',
  data_scope           char(1)         default '1'                comment '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  menu_check_strictly  tinyint(1)      default 1                  comment '菜单树选择项是否关联显示',
  dept_check_strictly  tinyint(1)      default 1                  comment '部门树选择项是否关联显示',
  status               char(1)         not null                   comment '角色状态（0正常 1停用）',
  del_flag             char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by            varchar(64)     default ''                 comment '创建者',
  create_time          datetime                                   comment '创建时间',
  update_by            varchar(64)     default ''                 comment '更新者',
  update_time          datetime                                   comment '更新时间',
  remark               varchar(500)    default null               comment '备注',
  primary key (role_id)
) engine=innodb auto_increment=100 comment = '角色信息表';

-- ----------------------------
-- 初始化-角色信息表数据
-- ----------------------------
insert into sys_role values('1', '超级管理员',  'admin',  1, 1, 1, 1, '0', '0', 'admin', sysdate(), '', null, '超级管理员');
insert into sys_role values('2', '普通角色',    'common', 2, 2, 1, 1, '0', '0', 'admin', sysdate(), '', null, '普通角色');


-- ----------------------------
-- 5、菜单权限表
-- ----------------------------
drop table if exists sys_menu;
create table sys_menu (
  menu_id           bigint(20)      not null auto_increment    comment '菜单ID',
  menu_name         varchar(50)     not null                   comment '菜单名称',
  parent_id         bigint(20)      default 0                  comment '父菜单ID',
  order_num         int(4)          default 0                  comment '显示顺序',
  path              varchar(200)    default ''                 comment '路由地址',
  component         varchar(255)    default null               comment '组件路径',
  query             varchar(255)    default null               comment '路由参数',
  route_name        varchar(50)     default ''                 comment '路由名称',
  is_frame          int(1)          default 1                  comment '是否为外链（0是 1否）',
  is_cache          int(1)          default 0                  comment '是否缓存（0缓存 1不缓存）',
  menu_type         char(1)         default ''                 comment '菜单类型（M目录 C菜单 F按钮）',
  visible           char(1)         default 0                  comment '菜单状态（0显示 1隐藏）',
  status            char(1)         default 0                  comment '菜单状态（0正常 1停用）',
  perms             varchar(100)    default null               comment '权限标识',
  icon              varchar(100)    default '#'                comment '菜单图标',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''                 comment '备注',
  primary key (menu_id)
) engine=innodb auto_increment=2000 comment = '菜单权限表';

-- ----------------------------
-- 初始化-菜单信息表数据
-- ----------------------------
-- 一级菜单
insert into sys_menu values('1', '系统管理', '0', '1', 'system',           null, '', '', 1, 0, 'M', '0', '0', '', 'system',   'admin', sysdate(), '', null, '系统管理目录');
insert into sys_menu values('2', '系统监控', '0', '2', 'monitor',          null, '', '', 1, 0, 'M', '0', '0', '', 'monitor',  'admin', sysdate(), '', null, '系统监控目录');
insert into sys_menu values('3', '系统工具', '0', '3', 'tool',             null, '', '', 1, 0, 'M', '0', '0', '', 'tool',     'admin', sysdate(), '', null, '系统工具目录');
insert into sys_menu values('4', '官网', '0', '4', 'http://ruoyi.vip', null, '', '', 0, 0, 'M', '0', '0', '', 'guide',    'admin', sysdate(), '', null, '官网地址');
-- 二级菜单
insert into sys_menu values('100',  '用户管理', '1',   '1', 'user',       'system/user/index',        '', '', 1, 0, 'C', '0', '0', 'system:user:list',        'user',          'admin', sysdate(), '', null, '用户管理菜单');
insert into sys_menu values('101',  '角色管理', '1',   '2', 'role',       'system/role/index',        '', '', 1, 0, 'C', '0', '0', 'system:role:list',        'peoples',       'admin', sysdate(), '', null, '角色管理菜单');
insert into sys_menu values('102',  '菜单管理', '1',   '3', 'menu',       'system/menu/index',        '', '', 1, 0, 'C', '0', '0', 'system:menu:list',        'tree-table',    'admin', sysdate(), '', null, '菜单管理菜单');
insert into sys_menu values('103',  '部门管理', '1',   '4', 'dept',       'system/dept/index',        '', '', 1, 0, 'C', '0', '0', 'system:dept:list',        'tree',          'admin', sysdate(), '', null, '部门管理菜单');
insert into sys_menu values('104',  '岗位管理', '1',   '5', 'post',       'system/post/index',        '', '', 1, 0, 'C', '0', '0', 'system:post:list',        'post',          'admin', sysdate(), '', null, '岗位管理菜单');
insert into sys_menu values('105',  '字典管理', '1',   '6', 'dict',       'system/dict/index',        '', '', 1, 0, 'C', '0', '0', 'system:dict:list',        'dict',          'admin', sysdate(), '', null, '字典管理菜单');
insert into sys_menu values('106',  '参数设置', '1',   '7', 'config',     'system/config/index',      '', '', 1, 0, 'C', '0', '0', 'system:config:list',      'edit',          'admin', sysdate(), '', null, '参数设置菜单');
insert into sys_menu values('107',  '通知公告', '1',   '8', 'notice',     'system/notice/index',      '', '', 1, 0, 'C', '0', '0', 'system:notice:list',      'message',       'admin', sysdate(), '', null, '通知公告菜单');
insert into sys_menu values('108',  '日志管理', '1',   '9', 'log',        '',                         '', '', 1, 0, 'M', '0', '0', '',                        'log',           'admin', sysdate(), '', null, '日志管理菜单');
insert into sys_menu values('118',  '编码规则', '1',   '10', 'codeRule',  'system/codeRule/index',    '', '', 1, 0, 'C', '0', '0', 'system:codeRule:list',    'number',        'admin', sysdate(), '', null, '编码规则菜单');
insert into sys_menu values('109',  '在线用户', '2',   '1', 'online',     'monitor/online/index',     '', '', 1, 0, 'C', '0', '0', 'monitor:online:list',     'online',        'admin', sysdate(), '', null, '在线用户菜单');
insert into sys_menu values('110',  '定时任务', '2',   '2', 'job',        'monitor/job/index',        '', '', 1, 0, 'C', '0', '0', 'monitor:job:list',        'job',           'admin', sysdate(), '', null, '定时任务菜单');
insert into sys_menu values('111',  '数据监控', '2',   '3', 'druid',      'monitor/druid/index',      '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list',      'druid',         'admin', sysdate(), '', null, '数据监控菜单');
insert into sys_menu values('112',  '服务监控', '2',   '4', 'server',     'monitor/server/index',     '', '', 1, 0, 'C', '0', '0', 'monitor:server:list',     'server',        'admin', sysdate(), '', null, '服务监控菜单');
insert into sys_menu values('113',  '缓存监控', '2',   '5', 'cache',      'monitor/cache/index',      '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list',      'redis',         'admin', sysdate(), '', null, '缓存监控菜单');
insert into sys_menu values('114',  '缓存列表', '2',   '6', 'cacheList',  'monitor/cache/list',       '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list',      'redis-list',    'admin', sysdate(), '', null, '缓存列表菜单');
insert into sys_menu values('115',  '表单构建', '3',   '1', 'build',      'tool/build/index',         '', '', 1, 0, 'C', '0', '0', 'tool:build:list',         'build',         'admin', sysdate(), '', null, '表单构建菜单');
insert into sys_menu values('116',  '代码生成', '3',   '2', 'gen',        'tool/gen/index',           '', '', 1, 0, 'C', '0', '0', 'tool:gen:list',           'code',          'admin', sysdate(), '', null, '代码生成菜单');
insert into sys_menu values('117',  '系统接口', '3',   '3', 'swagger',    'tool/swagger/index',       '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list',       'swagger',       'admin', sysdate(), '', null, '系统接口菜单');
-- 三级菜单
insert into sys_menu values('500',  '操作日志', '108', '1', 'operlog',    'monitor/operlog/index',    '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list',    'form',          'admin', sysdate(), '', null, '操作日志菜单');
insert into sys_menu values('501',  '登录日志', '108', '2', 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor',    'admin', sysdate(), '', null, '登录日志菜单');
-- 用户管理按钮
insert into sys_menu values('1000', '用户查询', '100', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1001', '用户新增', '100', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1002', '用户修改', '100', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1003', '用户删除', '100', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1004', '用户导出', '100', '5',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1005', '用户导入', '100', '6',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1006', '重置密码', '100', '7',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd',       '#', 'admin', sysdate(), '', null, '');
-- 角色管理按钮
insert into sys_menu values('1007', '角色查询', '101', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1008', '角色新增', '101', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1009', '角色修改', '101', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1010', '角色删除', '101', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1011', '角色导出', '101', '5',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export',         '#', 'admin', sysdate(), '', null, '');
-- 菜单管理按钮
insert into sys_menu values('1012', '菜单查询', '102', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1013', '菜单新增', '102', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1014', '菜单修改', '102', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1015', '菜单删除', '102', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove',         '#', 'admin', sysdate(), '', null, '');
-- 部门管理按钮
insert into sys_menu values('1016', '部门查询', '103', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1017', '部门新增', '103', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1018', '部门修改', '103', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1019', '部门删除', '103', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove',         '#', 'admin', sysdate(), '', null, '');
-- 岗位管理按钮
insert into sys_menu values('1020', '岗位查询', '104', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1021', '岗位新增', '104', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1022', '岗位修改', '104', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1023', '岗位删除', '104', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1024', '岗位导出', '104', '5',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export',         '#', 'admin', sysdate(), '', null, '');
-- 字典管理按钮
insert into sys_menu values('1025', '字典查询', '105', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1026', '字典新增', '105', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1027', '字典修改', '105', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1028', '字典删除', '105', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1029', '字典导出', '105', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export',         '#', 'admin', sysdate(), '', null, '');
-- 参数设置按钮
insert into sys_menu values('1030', '参数查询', '106', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1031', '参数新增', '106', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1032', '参数修改', '106', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1033', '参数删除', '106', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove',       '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1034', '参数导出', '106', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export',       '#', 'admin', sysdate(), '', null, '');
-- 通知公告按钮
insert into sys_menu values('1035', '公告查询', '107', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1036', '公告新增', '107', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1037', '公告修改', '107', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1038', '公告删除', '107', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove',       '#', 'admin', sysdate(), '', null, '');
-- 操作日志按钮
insert into sys_menu values('1039', '操作查询', '500', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query',      '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1040', '操作删除', '500', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove',     '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1041', '日志导出', '500', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export',     '#', 'admin', sysdate(), '', null, '');
-- 登录日志按钮
insert into sys_menu values('1042', '登录查询', '501', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query',   '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1043', '登录删除', '501', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove',  '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1044', '日志导出', '501', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export',  '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1045', '账户解锁', '501', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock',  '#', 'admin', sysdate(), '', null, '');
-- 在线用户按钮
insert into sys_menu values('1046', '在线查询', '109', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query',       '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1047', '批量强退', '109', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1048', '单条强退', '109', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', sysdate(), '', null, '');
-- 定时任务按钮
insert into sys_menu values('1049', '任务查询', '110', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1050', '任务新增', '110', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1051', '任务修改', '110', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1052', '任务删除', '110', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1053', '状态修改', '110', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus',   '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1054', '任务导出', '110', '6', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export',         '#', 'admin', sysdate(), '', null, '');
-- 代码生成按钮
insert into sys_menu values('1055', '生成查询', '116', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query',             '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1056', '生成修改', '116', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit',              '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1057', '生成删除', '116', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1058', '导入代码', '116', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1059', '预览代码', '116', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1060', '生成代码', '116', '6', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code',              '#', 'admin', sysdate(), '', null, '');
-- 编码规则按钮
insert into sys_menu values('1070', '规则查询', '118', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:codeRule:query',      '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1071', '规则新增', '118', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:codeRule:add',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1072', '规则修改', '118', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:codeRule:edit',       '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1073', '规则删除', '118', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:codeRule:remove',     '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1074', '规则导出', '118', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:codeRule:export',     '#', 'admin', sysdate(), '', null, '');


-- ----------------------------
-- 6、用户和角色关联表  用户N-1角色
-- ----------------------------
drop table if exists sys_user_role;
create table sys_user_role (
  user_id   bigint(20) not null comment '用户ID',
  role_id   bigint(20) not null comment '角色ID',
  primary key(user_id, role_id)
) engine=innodb comment = '用户和角色关联表';

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
  role_id   bigint(20) not null comment '角色ID',
  menu_id   bigint(20) not null comment '菜单ID',
  primary key(role_id, menu_id)
) engine=innodb comment = '角色和菜单关联表';

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
  role_id   bigint(20) not null comment '角色ID',
  dept_id   bigint(20) not null comment '部门ID',
  primary key(role_id, dept_id)
) engine=innodb comment = '角色和部门关联表';

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
  user_id   bigint(20) not null comment '用户ID',
  post_id   bigint(20) not null comment '岗位ID',
  primary key (user_id, post_id)
) engine=innodb comment = '用户与岗位关联表';

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
  oper_id           bigint(20)      not null auto_increment    comment '日志主键',
  title             varchar(50)     default ''                 comment '模块标题',
  business_type     int(2)          default 0                  comment '业务类型（0其它 1新增 2修改 3删除）',
  method            varchar(200)    default ''                 comment '方法名称',
  request_method    varchar(10)     default ''                 comment '请求方式',
  operator_type     int(1)          default 0                  comment '操作类别（0其它 1后台用户 2手机端用户）',
  oper_name         varchar(50)     default ''                 comment '操作人员',
  dept_name         varchar(50)     default ''                 comment '部门名称',
  oper_url          varchar(255)    default ''                 comment '请求URL',
  oper_ip           varchar(128)    default ''                 comment '主机地址',
  oper_location     varchar(255)    default ''                 comment '操作地点',
  oper_param        varchar(2000)   default ''                 comment '请求参数',
  json_result       varchar(2000)   default ''                 comment '返回参数',
  status            int(1)          default 0                  comment '操作状态（0正常 1异常）',
  error_msg         varchar(2000)   default ''                 comment '错误消息',
  oper_time         datetime                                   comment '操作时间',
  cost_time         bigint(20)      default 0                  comment '消耗时间',
  primary key (oper_id),
  key idx_sys_oper_log_bt (business_type),
  key idx_sys_oper_log_s  (status),
  key idx_sys_oper_log_ot (oper_time)
) engine=innodb auto_increment=100 comment = '操作日志记录';


-- ----------------------------
-- 11、字典类型表
-- ----------------------------
drop table if exists sys_dict_type;
create table sys_dict_type
(
  dict_id          bigint(20)      not null auto_increment    comment '字典主键',
  dict_name        varchar(100)    default ''                 comment '字典名称',
  dict_type        varchar(100)    default ''                 comment '字典类型',
  status           char(1)         default '0'                comment '状态（0正常 1停用）',
  create_by        varchar(64)     default ''                 comment '创建者',
  create_time      datetime                                   comment '创建时间',
  update_by        varchar(64)     default ''                 comment '更新者',
  update_time      datetime                                   comment '更新时间',
  remark           varchar(500)    default null               comment '备注',
  primary key (dict_id),
  unique (dict_type)
) engine=innodb auto_increment=100 comment = '字典类型表';

insert into sys_dict_type values(1,  '用户性别', 'sys_user_sex',        '0', 'admin', sysdate(), '', null, '用户性别列表');
insert into sys_dict_type values(2,  '菜单状态', 'sys_show_hide',       '0', 'admin', sysdate(), '', null, '菜单状态列表');
insert into sys_dict_type values(3,  '系统开关', 'sys_normal_disable',  '0', 'admin', sysdate(), '', null, '系统开关列表');
insert into sys_dict_type values(4,  '任务状态', 'sys_job_status',      '0', 'admin', sysdate(), '', null, '任务状态列表');
insert into sys_dict_type values(5,  '任务分组', 'sys_job_group',       '0', 'admin', sysdate(), '', null, '任务分组列表');
insert into sys_dict_type values(6,  '系统是否', 'sys_yes_no',          '0', 'admin', sysdate(), '', null, '系统是否列表');
insert into sys_dict_type values(7,  '通知类型', 'sys_notice_type',     '0', 'admin', sysdate(), '', null, '通知类型列表');
insert into sys_dict_type values(8,  '通知状态', 'sys_notice_status',   '0', 'admin', sysdate(), '', null, '通知状态列表');
insert into sys_dict_type values(9,  '操作类型', 'sys_oper_type',       '0', 'admin', sysdate(), '', null, '操作类型列表');
insert into sys_dict_type values(10, '系统状态', 'sys_common_status',   '0', 'admin', sysdate(), '', null, '登录状态列表');


-- ----------------------------
-- 12、字典数据表
-- ----------------------------
drop table if exists sys_dict_data;
create table sys_dict_data
(
  dict_code        bigint(20)      not null auto_increment    comment '字典编码',
  dict_sort        int(4)          default 0                  comment '字典排序',
  dict_label       varchar(100)    default ''                 comment '字典标签',
  dict_value       varchar(100)    default ''                 comment '字典键值',
  dict_type        varchar(100)    default ''                 comment '字典类型',
  css_class        varchar(100)    default null               comment '样式属性（其他样式扩展）',
  list_class       varchar(100)    default null               comment '表格回显样式',
  is_default       char(1)         default 'N'                comment '是否默认（Y是 N否）',
  status           char(1)         default '0'                comment '状态（0正常 1停用）',
  create_by        varchar(64)     default ''                 comment '创建者',
  create_time      datetime                                   comment '创建时间',
  update_by        varchar(64)     default ''                 comment '更新者',
  update_time      datetime                                   comment '更新时间',
  remark           varchar(500)    default null               comment '备注',
  primary key (dict_code)
) engine=innodb auto_increment=100 comment = '字典数据表';

insert into sys_dict_data values(1,  1,  '男',       '0',       'sys_user_sex',        '',   '',        'Y', '0', 'admin', sysdate(), '', null, '性别男');
insert into sys_dict_data values(2,  2,  '女',       '1',       'sys_user_sex',        '',   '',        'N', '0', 'admin', sysdate(), '', null, '性别女');
insert into sys_dict_data values(3,  3,  '未知',     '2',       'sys_user_sex',        '',   '',        'N', '0', 'admin', sysdate(), '', null, '性别未知');
insert into sys_dict_data values(4,  1,  '显示',     '0',       'sys_show_hide',       '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '显示菜单');
insert into sys_dict_data values(5,  2,  '隐藏',     '1',       'sys_show_hide',       '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '隐藏菜单');
insert into sys_dict_data values(6,  1,  '正常',     '0',       'sys_normal_disable',  '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '正常状态');
insert into sys_dict_data values(7,  2,  '停用',     '1',       'sys_normal_disable',  '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '停用状态');
insert into sys_dict_data values(8,  1,  '正常',     '0',       'sys_job_status',      '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '正常状态');
insert into sys_dict_data values(9,  2,  '暂停',     '1',       'sys_job_status',      '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '停用状态');
insert into sys_dict_data values(10, 1,  '默认',     'DEFAULT', 'sys_job_group',       '',   '',        'Y', '0', 'admin', sysdate(), '', null, '默认分组');
insert into sys_dict_data values(11, 2,  '系统',     'SYSTEM',  'sys_job_group',       '',   '',        'N', '0', 'admin', sysdate(), '', null, '系统分组');
insert into sys_dict_data values(12, 1,  '是',       'Y',       'sys_yes_no',          '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '系统默认是');
insert into sys_dict_data values(13, 2,  '否',       'N',       'sys_yes_no',          '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '系统默认否');
insert into sys_dict_data values(14, 1,  '通知',     '1',       'sys_notice_type',     '',   'warning', 'Y', '0', 'admin', sysdate(), '', null, '通知');
insert into sys_dict_data values(15, 2,  '公告',     '2',       'sys_notice_type',     '',   'success', 'N', '0', 'admin', sysdate(), '', null, '公告');
insert into sys_dict_data values(16, 1,  '正常',     '0',       'sys_notice_status',   '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '正常状态');
insert into sys_dict_data values(17, 2,  '关闭',     '1',       'sys_notice_status',   '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '关闭状态');
insert into sys_dict_data values(18, 99, '其他',     '0',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', sysdate(), '', null, '其他操作');
insert into sys_dict_data values(19, 1,  '新增',     '1',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', sysdate(), '', null, '新增操作');
insert into sys_dict_data values(20, 2,  '修改',     '2',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', sysdate(), '', null, '修改操作');
insert into sys_dict_data values(21, 3,  '删除',     '3',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '删除操作');
insert into sys_dict_data values(22, 4,  '授权',     '4',       'sys_oper_type',       '',   'primary', 'N', '0', 'admin', sysdate(), '', null, '授权操作');
insert into sys_dict_data values(23, 5,  '导出',     '5',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', sysdate(), '', null, '导出操作');
insert into sys_dict_data values(24, 6,  '导入',     '6',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', sysdate(), '', null, '导入操作');
insert into sys_dict_data values(25, 7,  '强退',     '7',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '强退操作');
insert into sys_dict_data values(26, 8,  '生成代码', '8',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', sysdate(), '', null, '生成操作');
insert into sys_dict_data values(27, 9,  '清空数据', '9',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '清空操作');
insert into sys_dict_data values(28, 1,  '成功',     '0',       'sys_common_status',   '',   'primary', 'N', '0', 'admin', sysdate(), '', null, '正常状态');
insert into sys_dict_data values(29, 2,  '失败',     '1',       'sys_common_status',   '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '停用状态');


-- ----------------------------
-- 13、参数配置表
-- ----------------------------
drop table if exists sys_config;
create table sys_config (
  config_id         int(5)          not null auto_increment    comment '参数主键',
  config_name       varchar(100)    default ''                 comment '参数名称',
  config_key        varchar(100)    default ''                 comment '参数键名',
  config_value      varchar(500)    default ''                 comment '参数键值',
  config_type       char(1)         default 'N'                comment '系统内置（Y是 N否）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (config_id)
) engine=innodb auto_increment=100 comment = '参数配置表';

insert into sys_config values(1, '主框架页-默认皮肤样式名称',     'sys.index.skinName',               'skin-blue',     'Y', 'admin', sysdate(), '', null, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow' );
insert into sys_config values(2, '用户管理-账号初始密码',         'sys.user.initPassword',            '123456',        'Y', 'admin', sysdate(), '', null, '初始化密码 123456' );
insert into sys_config values(3, '主框架页-侧边栏主题',           'sys.index.sideTheme',              'theme-dark',    'Y', 'admin', sysdate(), '', null, '深色主题theme-dark，浅色主题theme-light' );
insert into sys_config values(4, '账号自助-验证码开关',           'sys.account.captchaEnabled',       'false',         'Y', 'admin', sysdate(), '', null, '是否开启验证码功能（true开启，false关闭）');
insert into sys_config values(5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser',         'false',         'Y', 'admin', sysdate(), '', null, '是否开启注册用户功能（true开启，false关闭）');
insert into sys_config values(6, '用户登录-黑名单列表',           'sys.login.blackIPList',            '',              'Y', 'admin', sysdate(), '', null, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
insert into sys_config values(7, '用户管理-初始密码修改策略',     'sys.account.initPasswordModify',   '1',             'Y', 'admin', sysdate(), '', null, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
insert into sys_config values(8, '用户管理-账号密码更新周期',     'sys.account.passwordValidateDays', '0',             'Y', 'admin', sysdate(), '', null, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');


-- ----------------------------
-- 14、系统访问记录
-- ----------------------------
drop table if exists sys_logininfor;
create table sys_logininfor (
  info_id        bigint(20)     not null auto_increment   comment '访问ID',
  user_name      varchar(50)    default ''                comment '用户账号',
  ipaddr         varchar(128)   default ''                comment '登录IP地址',
  login_location varchar(255)   default ''                comment '登录地点',
  browser        varchar(50)    default ''                comment '浏览器类型',
  os             varchar(50)    default ''                comment '操作系统',
  status         char(1)        default '0'               comment '登录状态（0成功 1失败）',
  msg            varchar(255)   default ''                comment '提示消息',
  login_time     datetime                                 comment '访问时间',
  primary key (info_id),
  key idx_sys_logininfor_s  (status),
  key idx_sys_logininfor_lt (login_time)
) engine=innodb auto_increment=100 comment = '系统访问记录';


-- ----------------------------
-- 15、定时任务调度表
-- ----------------------------
drop table if exists sys_job;
create table sys_job (
  job_id              bigint(20)    not null auto_increment    comment '任务ID',
  job_name            varchar(64)   default ''                 comment '任务名称',
  job_group           varchar(64)   default 'DEFAULT'          comment '任务组名',
  invoke_target       varchar(500)  not null                   comment '调用目标字符串',
  cron_expression     varchar(255)  default ''                 comment 'cron执行表达式',
  misfire_policy      varchar(20)   default '3'                comment '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  concurrent          char(1)       default '1'                comment '是否并发执行（0允许 1禁止）',
  status              char(1)       default '0'                comment '状态（0正常 1暂停）',
  create_by           varchar(64)   default ''                 comment '创建者',
  create_time         datetime                                 comment '创建时间',
  update_by           varchar(64)   default ''                 comment '更新者',
  update_time         datetime                                 comment '更新时间',
  remark              varchar(500)  default ''                 comment '备注信息',
  primary key (job_id, job_name, job_group)
) engine=innodb auto_increment=100 comment = '定时任务调度表';

insert into sys_job values(1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams',        '0/10 * * * * ?', '3', '1', '1', 'admin', sysdate(), '', null, '');
insert into sys_job values(2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')',  '0/15 * * * * ?', '3', '1', '1', 'admin', sysdate(), '', null, '');
insert into sys_job values(3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)',  '0/20 * * * * ?', '3', '1', '1', 'admin', sysdate(), '', null, '');


-- ----------------------------
-- 16、定时任务调度日志表
-- ----------------------------
drop table if exists sys_job_log;
create table sys_job_log (
  job_log_id          bigint(20)     not null auto_increment    comment '任务日志ID',
  job_name            varchar(64)    not null                   comment '任务名称',
  job_group           varchar(64)    not null                   comment '任务组名',
  invoke_target       varchar(500)   not null                   comment '调用目标字符串',
  job_message         varchar(500)                              comment '日志信息',
  status              char(1)        default '0'                comment '执行状态（0正常 1失败）',
  exception_info      varchar(2000)  default ''                 comment '异常信息',
  start_time          datetime                                  comment '执行开始时间',
  end_time            datetime                                  comment '执行结束时间',
  create_time         datetime                                  comment '创建时间',
  primary key (job_log_id)
) engine=innodb comment = '定时任务调度日志表';


-- ----------------------------
-- 17、通知公告表
-- ----------------------------
drop table if exists sys_notice;
create table sys_notice (
  notice_id         int(4)          not null auto_increment    comment '公告ID',
  notice_title      varchar(50)     not null                   comment '公告标题',
  notice_type       char(1)         not null                   comment '公告类型（1通知 2公告）',
  notice_content    longblob        default null               comment '公告内容',
  status            char(1)         default '0'                comment '公告状态（0正常 1关闭）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(255)    default null               comment '备注',
  primary key (notice_id)
) engine=innodb auto_increment=10 comment = '通知公告表';

-- ----------------------------
-- 初始化-公告信息表数据
-- ----------------------------
insert into sys_notice values('1', '温馨提醒：2018-07-01 新版本发布啦', '2', '新版本内容', '0', 'admin', sysdate(), '', null, '管理员');
insert into sys_notice values('2', '维护通知：2018-07-01 系统凌晨维护', '1', '维护内容',   '0', 'admin', sysdate(), '', null, '管理员');
insert into sys_notice values('3', '开源框架介绍', '1', '<p><span style=\"color: rgb(230, 0, 0);\">项目介绍</span></p><p><font color=\"#333333\">RuoYi开源项目是为企业用户定制的后台脚手架框架，为企业打造的一站式解决方案，降低企业开发成本，提升开发效率。主要包括用户管理、角色管理、部门管理、菜单管理、参数管理、字典管理、</font><span style=\"color: rgb(51, 51, 51);\">岗位管理</span><span style=\"color: rgb(51, 51, 51);\">、定时任务</span><span style=\"color: rgb(51, 51, 51);\">、</span><span style=\"color: rgb(51, 51, 51);\">服务监控、登录日志、操作日志、代码生成等功能。其中，还支持多数据源、数据权限、国际化、Redis缓存、Docker部署、滑动验证码、第三方认证登录、分布式事务、</span><font color=\"#333333\">分布式文件存储</font><span style=\"color: rgb(51, 51, 51);\">、分库分表处理等技术特点。</span></p><p><img src=\"https://foruda.gitee.com/images/1773931848342439032/a4d22313_1815095.png\" style=\"width: 64px;\"><br></p><p><span style=\"color: rgb(230, 0, 0);\">官网及演示</span></p><p><span style=\"color: rgb(51, 51, 51);\">官网地址：&nbsp;</span><a href=\"http://ruoyi.vip\" target=\"_blank\">http://ruoyi.vip</a><a href=\"http://ruoyi.vip\" target=\"_blank\"></a></p><p><span style=\"color: rgb(51, 51, 51);\">文档地址：&nbsp;</span><a href=\"http://doc.ruoyi.vip\" target=\"_blank\">http://doc.ruoyi.vip</a><br></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【不分离版】：&nbsp;</span><a href=\"http://demo.ruoyi.vip\" target=\"_blank\">http://demo.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【分离版本】：&nbsp;</span><a href=\"http://vue.ruoyi.vip\" target=\"_blank\">http://vue.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【微服务版】：&nbsp;</span><a href=\"http://cloud.ruoyi.vip\" target=\"_blank\">http://cloud.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【移动端版】：&nbsp;</span><a href=\"http://h5.ruoyi.vip\" target=\"_blank\">http://h5.ruoyi.vip</a></p><p><br style=\"color: rgb(48, 49, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px;\"></p>', '0', 'admin', sysdate(), '', null, '管理员');


-- ----------------------------
-- 18、公告已读记录表
-- ----------------------------
drop table if exists sys_notice_read;
create table sys_notice_read (
  read_id          bigint(20)       not null auto_increment    comment '已读主键',
  notice_id        int(4)           not null                   comment '公告id',
  user_id          bigint(20)       not null                   comment '用户id',
  read_time        datetime         not null                   comment '阅读时间',
  primary key (read_id),
  unique key uk_user_notice (user_id, notice_id)   comment '同一用户同一公告只记录一次'
) engine=innodb auto_increment=1 comment='公告已读记录表';


-- ----------------------------
-- 19、代码生成业务表
-- ----------------------------
drop table if exists gen_table;
create table gen_table (
  table_id          bigint(20)      not null auto_increment    comment '编号',
  table_name        varchar(200)    default ''                 comment '表名称',
  table_comment     varchar(500)    default ''                 comment '表描述',
  sub_table_name    varchar(64)     default null               comment '关联子表的表名',
  sub_table_fk_name varchar(64)     default null               comment '子表关联的外键名',
  class_name        varchar(100)    default ''                 comment '实体类名称',
  tpl_category      varchar(200)    default 'crud'             comment '使用的模板（crud单表操作 tree树表操作）',
  tpl_web_type      varchar(30)     default ''                 comment '前端模板类型（element-ui模版 element-plus模版）',
  package_name      varchar(100)                               comment '生成包路径',
  module_name       varchar(30)                                comment '生成模块名',
  business_name     varchar(30)                                comment '生成业务名',
  function_name     varchar(50)                                comment '生成功能名',
  function_author   varchar(50)                                comment '生成功能作者',
  gen_type          char(1)         default '0'                comment '生成代码方式（0zip压缩包 1自定义路径）',
  gen_path          varchar(200)    default '/'                comment '生成路径（不填默认项目路径）',
  options           varchar(1000)                              comment '其它生成选项',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (table_id)
) engine=innodb auto_increment=1 comment = '代码生成业务表';


-- ----------------------------
-- 20、代码生成业务表字段
-- ----------------------------
drop table if exists gen_table_column;
create table gen_table_column (
  column_id         bigint(20)      not null auto_increment    comment '编号',
  table_id          bigint(20)                                 comment '归属表编号',
  column_name       varchar(200)                               comment '列名称',
  column_comment    varchar(500)                               comment '列描述',
  column_type       varchar(100)                               comment '列类型',
  java_type         varchar(500)                               comment 'JAVA类型',
  java_field        varchar(200)                               comment 'JAVA字段名',
  is_pk             char(1)                                    comment '是否主键（1是）',
  is_increment      char(1)                                    comment '是否自增（1是）',
  is_required       char(1)                                    comment '是否必填（1是）',
  is_insert         char(1)                                    comment '是否为插入字段（1是）',
  is_edit           char(1)                                    comment '是否编辑字段（1是）',
  is_list           char(1)                                    comment '是否列表字段（1是）',
  is_query          char(1)                                    comment '是否查询字段（1是）',
  query_type        varchar(200)    default 'EQ'               comment '查询方式（等于、不等于、大于、小于、范围）',
  html_type         varchar(200)                               comment '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  dict_type         varchar(200)    default ''                 comment '字典类型',
  sort              int                                        comment '排序',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (column_id)
) engine=innodb auto_increment=1 comment = '代码生成业务表字段';

-- ----------------------------
-- MOM基础数据菜单
-- ----------------------------
insert into sys_menu values('2000', '基础数据', '0', '5', 'mom/base', null, '', '', 1, 0, 'M', '0', '0', '', 'build', 'admin', sysdate(), '', null, 'MOM基础数据目录');
insert into sys_menu values('2001', '物料数据', '2000', '1', 'material', 'mom/base/material/index', '', '', 1, 0, 'C', '0', '0', 'mom:base:material:list', 'component', 'admin', sysdate(), '', null, '物料数据菜单');
insert into sys_menu values('2007', '物料分类', '2000', '2', 'materialCategory', 'mom/base/materialCategory/index', '', '', 1, 0, 'C', '0', '0', 'mom:base:materialCategory:list', 'tree', 'admin', sysdate(), '', null, '物料分类菜单');
insert into sys_menu values('2003', '生产资源', '2000', '3', 'resource', 'mom/base/resource/index', '', '', 1, 0, 'C', '0', '0', 'mom:base:resource:list', 'tree', 'admin', sysdate(), '', null, '生产资源菜单');
insert into sys_menu values('2004', '班次日历', '2000', '4', 'calendar', 'mom/base/calendar/index', '', '', 1, 0, 'C', '0', '0', 'mom:base:calendar:list', 'date-range', 'admin', sysdate(), '', null, '班次日历菜单');
insert into sys_menu values('2005', '工艺路线', '2000', '5', 'routing', 'mom/base/routing/index', '', '', 1, 0, 'C', '0', '0', 'mom:base:routing:list', 'tree-table', 'admin', sysdate(), '', null, '工艺路线菜单');
insert into sys_menu values('2006', '工序/工步维护', '2000', '6', 'operation', 'mom/base/operation/index', '', '', 1, 0, 'C', '0', '0', 'mom:base:operation:list', 'list', 'admin', sysdate(), '', null, '工序工步维护菜单');
insert into sys_menu values('2200', 'MBOM管理', '0', '6', 'mom/mbom', null, '', '', 1, 0, 'M', '0', '0', '', 'tree-table', 'admin', sysdate(), '', null, 'MBOM管理目录');
insert into sys_menu values('2201', 'MBOM维护', '2200', '1', 'index', 'mom/mbom/index', '', '', 1, 0, 'C', '0', '0', 'mom:mbom:list', 'tree-table', 'admin', sysdate(), '', null, 'MBOM维护菜单');
insert into sys_menu values('2300', '生产管理', '0', '7', 'mom/production', null, '', '', 1, 0, 'M', '0', '0', '', 'form', 'admin', sysdate(), '', null, '生产管理目录');
insert into sys_menu values('2301', '生产工单', '2300', '1', 'workorder', 'mom/production/workorder/index', '', '', 1, 0, 'C', '0', '0', 'mom:workorder:list', 'form', 'admin', sysdate(), '', null, '生产工单菜单');
insert into sys_menu values('2302', '生产排产', '2300', '2', 'schedule', 'mom/production/schedule/index', '', '', 1, 0, 'C', '0', '0', 'mom:schedule:list', 'date-range', 'admin', sysdate(), '', null, '生产排产菜单');
insert into sys_menu values('2303', '工步报工', '2300', '3', 'report', 'mom/production/report/index', '', '', 1, 0, 'C', '0', '0', 'mom:report:list', 'edit', 'admin', sysdate(), '', null, '工步报工菜单');
insert into sys_menu values('2101', '物料查询', '2001', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:material:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2102', '物料新增', '2001', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:material:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2103', '物料修改', '2001', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:material:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2104', '物料删除', '2001', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:material:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2105', '物料导出', '2001', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:material:export', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2106', '物料导入', '2001', '6', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:material:import', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2161', '分类查询', '2007', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:materialCategory:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2162', '分类新增', '2007', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:materialCategory:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2163', '分类修改', '2007', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:materialCategory:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2164', '分类删除', '2007', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:materialCategory:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2121', '资源查询', '2003', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:resource:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2122', '资源新增', '2003', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:resource:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2123', '资源修改', '2003', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:resource:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2124', '资源删除', '2003', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:resource:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2125', '资源导出', '2003', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:resource:export', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2131', '日历查询', '2004', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:calendar:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2132', '日历新增', '2004', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:calendar:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2133', '日历修改', '2004', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:calendar:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2134', '日历删除', '2004', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:calendar:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2135', '日历导出', '2004', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:calendar:export', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2141', '路线查询', '2005', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:routing:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2142', '路线新增', '2005', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:routing:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2143', '路线修改', '2005', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:routing:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2144', '路线删除', '2005', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:routing:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2145', '路线导出', '2005', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:routing:export', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2151', '工序查询', '2006', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:operation:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2152', '工序新增', '2006', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:operation:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2153', '工序修改', '2006', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:operation:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2154', '工序删除', '2006', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:operation:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2155', '工序导出', '2006', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:operation:export', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2161', '工步查询', '2006', '6', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:step:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2162', '工步新增', '2006', '7', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:step:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2163', '工步修改', '2006', '8', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:step:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2164', '工步删除', '2006', '9', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:step:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2165', '工步导出', '2006', '10', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:base:step:export', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2211', 'MBOM查询', '2201', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2212', 'MBOM新增', '2201', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2213', 'MBOM修改', '2201', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2214', 'MBOM删除', '2201', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2215', 'MBOM导出', '2201', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:export', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2221', '明细查询', '2201', '6', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:item:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2222', '明细新增', '2201', '7', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:item:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2223', '明细修改', '2201', '8', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:item:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2224', '明细删除', '2201', '9', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:item:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2225', '明细导出', '2201', '10', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:mbom:item:export', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2311', '工单查询', '2301', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workorder:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2312', '工单新增', '2301', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workorder:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2313', '工单修改', '2301', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workorder:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2314', '工单删除', '2301', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workorder:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2315', '工单导出', '2301', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workorder:export', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2316', '工单下达', '2301', '6', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workorder:release', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2317', '工单开工', '2301', '7', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workorder:start', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2318', '工单完工', '2301', '8', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workorder:finish', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2319', '工单关闭', '2301', '9', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:workorder:close', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2321', '排产查询', '2302', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:schedule:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2322', '排产新增', '2302', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:schedule:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2323', '排产修改', '2302', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:schedule:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2324', '排产删除', '2302', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:schedule:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2325', '排产导出', '2302', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:schedule:export', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2326', '排产下达', '2302', '6', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:schedule:release', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2327', '排产开工', '2302', '7', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:schedule:start', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2328', '排产完工', '2302', '8', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:schedule:finish', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2329', '排产取消', '2302', '9', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:schedule:cancel', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2331', '报工查询', '2303', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:report:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2332', '报工新增', '2303', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:report:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2333', '报工删除', '2303', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:report:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2334', '报工导出', '2303', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'mom:report:export', '#', 'admin', sysdate(), '', null, '');

insert into sys_dict_type values(200, '物料类型', 'mom_material_type', '0', 'admin', sysdate(), '', null, 'MOM物料类型');
insert into sys_dict_type values(201, '资源类型', 'mom_resource_type', '0', 'admin', sysdate(), '', null, 'MOM资源类型');
insert into sys_dict_type values(202, '是否选项', 'mom_yes_no', '0', 'admin', sysdate(), '', null, 'MOM是否选项');
insert into sys_dict_type values(203, '投料方式', 'mom_issue_type', '0', 'admin', sysdate(), '', null, 'MOM投料方式');
insert into sys_dict_type values(204, '工单状态', 'mom_work_order_status', '0', 'admin', sysdate(), '', null, 'MOM工单状态');
insert into sys_dict_type values(205, '工单优先级', 'mom_work_order_priority', '0', 'admin', sysdate(), '', null, 'MOM工单优先级');
insert into sys_dict_type values(206, '排产状态', 'mom_schedule_status', '0', 'admin', sysdate(), '', null, 'MOM排产状态');
insert into sys_dict_type values(207, '报工状态', 'mom_report_status', '0', 'admin', sysdate(), '', null, 'MOM报工状态');
insert into sys_dict_data values(2000, 1, '原材料', 'raw', 'mom_material_type', '', 'primary', 'Y', '0', 'admin', sysdate(), '', null, '原材料');
insert into sys_dict_data values(2001, 2, '半成品', 'semi', 'mom_material_type', '', 'info', 'N', '0', 'admin', sysdate(), '', null, '半成品');
insert into sys_dict_data values(2002, 3, '成品', 'product', 'mom_material_type', '', 'success', 'N', '0', 'admin', sysdate(), '', null, '成品');
insert into sys_dict_data values(2003, 4, '辅料', 'aux', 'mom_material_type', '', 'warning', 'N', '0', 'admin', sysdate(), '', null, '辅料');
insert into sys_dict_data values(2009, 0, '工厂', 'factory', 'mom_resource_type', '', 'primary', 'N', '0', 'admin', sysdate(), '', null, '工厂');
insert into sys_dict_data values(2010, 1, '车间', 'workshop', 'mom_resource_type', '', 'primary', 'Y', '0', 'admin', sysdate(), '', null, '车间');
insert into sys_dict_data values(2011, 2, '产线', 'line', 'mom_resource_type', '', 'success', 'N', '0', 'admin', sysdate(), '', null, '产线');
insert into sys_dict_data values(2012, 3, '工位', 'station', 'mom_resource_type', '', 'warning', 'N', '0', 'admin', sysdate(), '', null, '工位');
insert into sys_dict_data values(2013, 4, '设备', 'equipment', 'mom_resource_type', '', 'info', 'N', '0', 'admin', sysdate(), '', null, '设备');
insert into sys_dict_data values(2014, 5, '库位', 'location', 'mom_resource_type', '', 'default', 'N', '0', 'admin', sysdate(), '', null, '库位');
insert into sys_dict_data values(2020, 1, '是', 'Y', 'mom_yes_no', '', 'primary', 'Y', '0', 'admin', sysdate(), '', null, '是');
insert into sys_dict_data values(2021, 2, '否', 'N', 'mom_yes_no', '', 'danger', 'N', '0', 'admin', sysdate(), '', null, '否');
insert into sys_dict_data values(2030, 1, '按单领料', 'order', 'mom_issue_type', '', 'primary', 'Y', '0', 'admin', sysdate(), '', null, '按单领料');
insert into sys_dict_data values(2031, 2, '工序投料', 'operation', 'mom_issue_type', '', 'success', 'N', '0', 'admin', sysdate(), '', null, '工序投料');
insert into sys_dict_data values(2032, 3, '倒冲扣料', 'backflush', 'mom_issue_type', '', 'warning', 'N', '0', 'admin', sysdate(), '', null, '倒冲扣料');
insert into sys_dict_data values(2040, 1, '草稿', 'draft', 'mom_work_order_status', '', 'info', 'Y', '0', 'admin', sysdate(), '', null, '草稿');
insert into sys_dict_data values(2041, 2, '已下达', 'released', 'mom_work_order_status', '', 'primary', 'N', '0', 'admin', sysdate(), '', null, '已下达');
insert into sys_dict_data values(2042, 3, '生产中', 'running', 'mom_work_order_status', '', 'warning', 'N', '0', 'admin', sysdate(), '', null, '生产中');
insert into sys_dict_data values(2043, 4, '已完工', 'finished', 'mom_work_order_status', '', 'success', 'N', '0', 'admin', sysdate(), '', null, '已完工');
insert into sys_dict_data values(2044, 5, '已关闭', 'closed', 'mom_work_order_status', '', 'danger', 'N', '0', 'admin', sysdate(), '', null, '已关闭');
insert into sys_dict_data values(2050, 1, '普通', 'normal', 'mom_work_order_priority', '', 'info', 'Y', '0', 'admin', sysdate(), '', null, '普通');
insert into sys_dict_data values(2051, 2, '加急', 'urgent', 'mom_work_order_priority', '', 'warning', 'N', '0', 'admin', sysdate(), '', null, '加急');
insert into sys_dict_data values(2052, 3, '紧急', 'critical', 'mom_work_order_priority', '', 'danger', 'N', '0', 'admin', sysdate(), '', null, '紧急');
insert into sys_dict_data values(2060, 1, '草稿', 'draft', 'mom_schedule_status', '', 'info', 'Y', '0', 'admin', sysdate(), '', null, '草稿');
insert into sys_dict_data values(2061, 2, '已下达', 'released', 'mom_schedule_status', '', 'primary', 'N', '0', 'admin', sysdate(), '', null, '已下达');
insert into sys_dict_data values(2062, 3, '生产中', 'running', 'mom_schedule_status', '', 'warning', 'N', '0', 'admin', sysdate(), '', null, '生产中');
insert into sys_dict_data values(2063, 4, '已完工', 'finished', 'mom_schedule_status', '', 'success', 'N', '0', 'admin', sysdate(), '', null, '已完工');
insert into sys_dict_data values(2064, 5, '已取消', 'cancelled', 'mom_schedule_status', '', 'danger', 'N', '0', 'admin', sysdate(), '', null, '已取消');
insert into sys_dict_data values(2070, 1, '已确认', 'confirmed', 'mom_report_status', '', 'success', 'Y', '0', 'admin', sysdate(), '', null, '已确认');

-- ----------------------------
-- MOM基础数据表
-- ----------------------------
drop table if exists mom_work_order;
drop table if exists mom_step_report;
drop table if exists mom_schedule;
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
  category_id bigint(20) not null auto_increment,
  parent_id bigint(20) default 0,
  ancestors varchar(50) default '',
  category_code varchar(64) not null,
  category_name varchar(100) not null,
  order_num int default 0,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time datetime,
  update_by varchar(64) default '',
  update_time datetime,
  remark varchar(500) default null,
  primary key (category_id),
  unique key uk_mom_material_category_code (category_code)
) engine=innodb auto_increment=1 comment='MOM物料分类';
create table mom_material (
  material_id bigint(20) not null auto_increment,
  material_code varchar(64) not null,
  material_name varchar(100) not null,
  spec_model varchar(100) default null,
  unit varchar(32) default null,
  category_id bigint(20) default null,
  material_type varchar(32) default null,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time datetime,
  update_by varchar(64) default '',
  update_time datetime,
  remark varchar(500) default null,
  primary key (material_id),
  unique key uk_mom_material_code (material_code)
) engine=innodb auto_increment=1 comment='MOM物料档案';
create table mom_product (
  product_id bigint(20) not null auto_increment,
  product_code varchar(64) not null,
  product_name varchar(100) not null,
  material_id bigint(20) default null,
  spec_model varchar(100) default null,
  unit varchar(32) default null,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time datetime,
  update_by varchar(64) default '',
  update_time datetime,
  remark varchar(500) default null,
  primary key (product_id),
  unique key uk_mom_product_code (product_code)
) engine=innodb auto_increment=1 comment='MOM产品档案';
create table mom_resource (
  resource_id bigint(20) not null auto_increment,
  resource_code varchar(64) not null,
  resource_name varchar(100) not null,
  resource_type varchar(32) default null,
  parent_id bigint(20) default 0,
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
  create_time datetime,
  update_by varchar(64) default '',
  update_time datetime,
  remark varchar(500) default null,
  primary key (resource_id),
  unique key uk_mom_resource_code (resource_code)
) engine=innodb auto_increment=1 comment='MOM生产资源';
create table mom_shift_calendar (
  calendar_id bigint(20) not null auto_increment,
  calendar_date date not null,
  shift_code varchar(64) not null,
  shift_name varchar(100) not null,
  start_time varchar(8) default null,
  end_time varchar(8) default null,
  is_workday char(1) default 'Y',
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time datetime,
  update_by varchar(64) default '',
  update_time datetime,
  remark varchar(500) default null,
  primary key (calendar_id),
  unique key uk_mom_calendar_shift (calendar_date, shift_code)
) engine=innodb auto_increment=1 comment='MOM班次日历';
create table mom_routing (
  routing_id bigint(20) not null auto_increment,
  routing_code varchar(64) not null,
  routing_name varchar(100) not null,
  product_id bigint(20) not null,
  version varchar(32) not null,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time datetime,
  update_by varchar(64) default '',
  update_time datetime,
  remark varchar(500) default null,
  primary key (routing_id),
  unique key uk_mom_routing_code (routing_code),
  unique key uk_mom_routing_product_version (product_id, version)
) engine=innodb auto_increment=1 comment='MOM工艺路线';
create table mom_operation (
  operation_id bigint(20) not null auto_increment,
  routing_id bigint(20) not null,
  operation_code varchar(64) not null,
  operation_name varchar(100) not null,
  operation_seq int not null,
  standard_minutes decimal(10,2) default null,
  resource_type varchar(32) default null,
  resource_id bigint default null,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time datetime,
  update_by varchar(64) default '',
  update_time datetime,
  remark varchar(500) default null,
  primary key (operation_id),
  unique key uk_mom_operation_seq (routing_id, operation_seq)
) engine=innodb auto_increment=1 comment='MOM工序';
create table mom_work_step (
  step_id bigint(20) not null auto_increment,
  operation_id bigint(20) not null,
  step_code varchar(64) not null,
  step_name varchar(100) not null,
  step_seq int not null,
  standard_minutes decimal(10,2) default null,
  is_report_point char(1) default 'Y',
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time datetime,
  update_by varchar(64) default '',
  update_time datetime,
  remark varchar(500) default null,
  primary key (step_id),
  unique key uk_mom_step_seq (operation_id, step_seq)
) engine=innodb auto_increment=1 comment='MOM工步';
create table mom_mbom (
  mbom_id bigint(20) not null auto_increment,
  mbom_code varchar(64) not null,
  mbom_name varchar(100) not null,
  product_id bigint(20) not null,
  version varchar(32) not null,
  effective_date date default null,
  expire_date date default null,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time datetime,
  update_by varchar(64) default '',
  update_time datetime,
  remark varchar(500) default null,
  primary key (mbom_id),
  unique key uk_mom_mbom_code (mbom_code),
  unique key uk_mom_mbom_product_version (product_id, version)
) engine=innodb auto_increment=1 comment='MOM制造BOM';
create table mom_mbom_item (
  item_id bigint(20) not null auto_increment,
  mbom_id bigint(20) not null,
  parent_item_id bigint(20) default 0,
  material_id bigint(20) not null,
  item_seq int not null,
  quantity decimal(18,6) not null,
  scrap_rate decimal(8,4) default 0,
  operation_id bigint(20) default null,
  step_id bigint(20) default null,
  issue_type varchar(32) default null,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time datetime,
  update_by varchar(64) default '',
  update_time datetime,
  remark varchar(500) default null,
  primary key (item_id),
  unique key uk_mom_mbom_item_seq (mbom_id, parent_item_id, item_seq)
) engine=innodb auto_increment=1 comment='MOM制造BOM明细';
create table mom_work_order (
  work_order_id bigint(20) not null auto_increment,
  work_order_code varchar(64) not null,
  work_order_name varchar(100) not null,
  product_id bigint(20) not null,
  mbom_id bigint(20) default null,
  routing_id bigint(20) default null,
  resource_id bigint(20) default null,
  plan_qty decimal(18,6) not null,
  completed_qty decimal(18,6) default 0,
  unit varchar(32) default null,
  priority varchar(32) default 'normal',
  source_order_code varchar(64) default null,
  plan_start_date date default null,
  plan_end_date date default null,
  actual_start_time datetime,
  actual_end_time datetime,
  status varchar(32) default 'draft',
  create_by varchar(64) default '',
  create_time datetime,
  update_by varchar(64) default '',
  update_time datetime,
  remark varchar(500) default null,
  primary key (work_order_id),
  unique key uk_mom_work_order_code (work_order_code)
) engine=innodb auto_increment=1 comment='MOM生产工单';
create table mom_schedule (
  schedule_id bigint(20) not null auto_increment,
  schedule_code varchar(64) not null,
  work_order_id bigint(20) not null,
  operation_id bigint(20) default null,
  resource_id bigint(20) not null,
  plan_start_time datetime not null,
  plan_end_time datetime not null,
  plan_qty decimal(18,6) not null,
  reported_qty decimal(18,6) default 0,
  status varchar(32) default 'draft',
  create_by varchar(64) default '',
  create_time datetime,
  update_by varchar(64) default '',
  update_time datetime,
  remark varchar(500) default null,
  primary key (schedule_id),
  unique key uk_mom_schedule_code (schedule_code)
) engine=innodb auto_increment=1 comment='MOM生产排产';
create table mom_step_report (
  report_id bigint(20) not null auto_increment,
  work_order_id bigint(20) not null,
  schedule_id bigint(20) default null,
  operation_id bigint(20) not null,
  step_id bigint(20) not null,
  resource_id bigint(20) default null,
  good_qty decimal(18,6) not null,
  bad_qty decimal(18,6) default 0,
  report_time datetime,
  report_user varchar(64) default '',
  status varchar(32) default 'confirmed',
  create_by varchar(64) default '',
  create_time datetime,
  update_by varchar(64) default '',
  update_time datetime,
  remark varchar(500) default null,
  primary key (report_id)
) engine=innodb auto_increment=1 comment='MOM工步报工';

insert into mom_material_category values(1, 0, '0', 'RAW', '原材料', 1, '0', 'admin', sysdate(), '', null, '原材料分类');
insert into mom_material_category values(2, 0, '0', 'AUX', '辅料', 2, '0', 'admin', sysdate(), '', null, '辅料分类');
insert into mom_material_category values(3, 0, '0', 'SEMI', '半成品', 3, '0', 'admin', sysdate(), '', null, '半成品分类');
insert into mom_material_category values(4, 0, '0', 'FG', '成品', 4, '0', 'admin', sysdate(), '', null, '成品分类');

insert into mom_material values(1, 'MAT-RAW-001', '铝型材坯料', '6061-T6 40x40', '根', 1, 'raw', '0', 'admin', sysdate(), '', null, '测试原材料');
insert into mom_material values(2, 'MAT-RAW-002', '紧固件套包', 'M6标准套包', '套', 2, 'aux', '0', 'admin', sysdate(), '', null, '测试辅料');
insert into mom_material values(3, 'MAT-SEMI-001', '装配半成品A', 'ASM-A', '件', 3, 'semi', '0', 'admin', sysdate(), '', null, '测试半成品');
insert into mom_material values(4, 'MAT-FG-001', '智能控制箱', 'ICB-100', '台', 4, 'product', '0', 'admin', sysdate(), '', null, '测试成品');
insert into mom_material values(5, 'MAT-FG-002', '标准驱动模块', 'DRV-200', '台', 4, 'product', '0', 'admin', sysdate(), '', null, '测试成品');

insert into mom_product values(1, 'PRD-ICB-100', '智能控制箱', 4, 'ICB-100', '台', '0', 'admin', sysdate(), '', null, '关联成品物料');
insert into mom_product values(2, 'PRD-DRV-200', '标准驱动模块', 5, 'DRV-200', '台', '0', 'admin', sysdate(), '', null, '关联成品物料');

insert into mom_resource(resource_id, resource_code, resource_name, resource_type, parent_id, workshop, line_code, status, station_note_flag, print_box_flag, print_nameplate_flag, line_type, station_type, skill_require, wip_capacity, create_by, create_time, update_by, update_time, remark) values(1, 'FAC-HZ', '杭州工厂', 'factory', 0, null, null, '0', 'N', 'N', 'N', null, null, null, 0, 'admin', sysdate(), '', null, '测试工厂');
insert into mom_resource(resource_id, resource_code, resource_name, resource_type, parent_id, workshop, line_code, status, station_note_flag, print_box_flag, print_nameplate_flag, line_type, station_type, skill_require, wip_capacity, create_by, create_time, update_by, update_time, remark) values(2, 'WS-01', '1号车间', 'workshop', 1, '1号车间', null, '0', 'N', 'N', 'N', null, null, null, 0, 'admin', sysdate(), '', null, '测试车间');
insert into mom_resource(resource_id, resource_code, resource_name, resource_type, parent_id, workshop, line_code, status, station_note_flag, print_box_flag, print_nameplate_flag, line_type, station_type, skill_require, wip_capacity, create_by, create_time, update_by, update_time, remark) values(3, 'L1', 'L1', 'line', 2, '1号车间', 'L1', '0', 'N', 'N', 'N', 'main', null, null, 0, 'admin', sysdate(), '', null, '测试产线');
insert into mom_resource(resource_id, resource_code, resource_name, resource_type, parent_id, workshop, line_code, status, station_note_flag, print_box_flag, print_nameplate_flag, line_type, station_type, skill_require, wip_capacity, create_by, create_time, update_by, update_time, remark) values(4, 'OP190-L1', 'OP190-L1', 'station', 3, '1号车间', 'L1', '0', 'N', 'N', 'N', 'main', null, null, 5, 'admin', sysdate(), '', null, '测试工位');
insert into mom_resource(resource_id, resource_code, resource_name, resource_type, parent_id, workshop, line_code, status, station_note_flag, print_box_flag, print_nameplate_flag, line_type, station_type, skill_require, wip_capacity, create_by, create_time, update_by, update_time, remark) values(5, 'OP180-L1', 'OP180-L1', 'station', 3, '1号车间', 'L1', '0', 'N', 'N', 'N', 'main', null, null, 5, 'admin', sysdate(), '', null, '测试工位');
insert into mom_resource(resource_id, resource_code, resource_name, resource_type, parent_id, workshop, line_code, status, station_note_flag, print_box_flag, print_nameplate_flag, line_type, station_type, skill_require, wip_capacity, create_by, create_time, update_by, update_time, remark) values(6, 'BIN-OP190-01', 'OP190库位01', 'location', 4, '1号车间', 'L1', '0', 'N', 'N', 'N', null, null, null, 0, 'admin', sysdate(), '', null, '工位库位');
insert into mom_resource(resource_id, resource_code, resource_name, resource_type, parent_id, workshop, line_code, status, station_note_flag, print_box_flag, print_nameplate_flag, line_type, station_type, skill_require, wip_capacity, create_by, create_time, update_by, update_time, remark) values(7, 'BIN-OP190-02', 'OP190库位02', 'location', 4, '1号车间', 'L1', '0', 'N', 'N', 'N', null, null, null, 0, 'admin', sysdate(), '', null, '工位库位');

insert into mom_shift_calendar values(1, '2026-06-08', 'DAY', '白班', '08:00', '17:00', 'Y', '0', 'admin', sysdate(), '', null, '测试班次');
insert into mom_shift_calendar values(2, '2026-06-08', 'NIGHT', '夜班', '20:00', '05:00', 'Y', '0', 'admin', sysdate(), '', null, '测试班次');
insert into mom_shift_calendar values(3, '2026-06-09', 'DAY', '白班', '08:00', '17:00', 'Y', '0', 'admin', sysdate(), '', null, '测试班次');

insert into mom_routing values(1, 'RT-ICB-100-V1', '智能控制箱标准路线', 4, 'V1', '0', 'admin', sysdate(), '', null, '测试工艺路线');
insert into mom_routing values(2, 'RT-DRV-200-V1', '标准驱动模块路线', 5, 'V1', '0', 'admin', sysdate(), '', null, '测试工艺路线');

insert into mom_operation values(1, 1, 'OP-010', '备料', 10, 15.00, 'station', 4, '0', 'admin', sysdate(), '', null, '测试工序');
insert into mom_operation values(2, 1, 'OP-020', '主体装配', 20, 35.00, 'station', 5, '0', 'admin', sysdate(), '', null, '测试工序');
insert into mom_operation values(3, 1, 'OP-030', '电气测试', 30, 20.00, 'station', 4, '0', 'admin', sysdate(), '', null, '测试工序');
insert into mom_operation values(4, 2, 'OP-010', '模块装配', 10, 25.00, 'station', 5, '0', 'admin', sysdate(), '', null, '测试工序');
insert into mom_operation values(5, 2, 'OP-020', '包装入库', 20, 10.00, 'station', 4, '0', 'admin', sysdate(), '', null, '测试工序');

insert into mom_work_step values(1, 1, 'STEP-010', '领取铝型材坯料', 10, 5.00, 'Y', '0', 'admin', sysdate(), '', null, '测试工步');
insert into mom_work_step values(2, 1, 'STEP-020', '核对紧固件套包', 20, 5.00, 'N', '0', 'admin', sysdate(), '', null, '测试工步');
insert into mom_work_step values(3, 2, 'STEP-010', '安装控制箱主体', 10, 20.00, 'Y', '0', 'admin', sysdate(), '', null, '测试工步');
insert into mom_work_step values(4, 2, 'STEP-020', '锁附紧固件', 20, 15.00, 'Y', '0', 'admin', sysdate(), '', null, '测试工步');
insert into mom_work_step values(5, 3, 'STEP-010', '通电测试', 10, 10.00, 'Y', '0', 'admin', sysdate(), '', null, '测试工步');
insert into mom_work_step values(6, 3, 'STEP-020', '记录测试结果', 20, 10.00, 'Y', '0', 'admin', sysdate(), '', null, '测试工步');
insert into mom_work_step values(7, 4, 'STEP-010', '模块预装', 10, 15.00, 'Y', '0', 'admin', sysdate(), '', null, '测试工步');
insert into mom_work_step values(8, 4, 'STEP-020', '外观检查', 20, 10.00, 'Y', '0', 'admin', sysdate(), '', null, '测试工步');
insert into mom_work_step values(9, 5, 'STEP-010', '贴标包装', 10, 10.00, 'Y', '0', 'admin', sysdate(), '', null, '测试工步');
insert into mom_mbom values(1, 'MBOM-ICB-100-V1', '智能控制箱制造BOM', 4, 'V1', '2026-06-08', null, '0', 'admin', sysdate(), '', null, '测试MBOM');
insert into mom_mbom values(2, 'MBOM-DRV-200-V1', '标准驱动模块制造BOM', 5, 'V1', '2026-06-08', null, '0', 'admin', sysdate(), '', null, '测试MBOM');
insert into mom_mbom_item values(1, 1, 0, 3, 10, 1.000000, 0.0000, 2, 3, 'operation', '0', 'admin', sysdate(), '', null, '半成品投入');
insert into mom_mbom_item values(2, 1, 1, 1, 10, 2.000000, 0.0200, 1, 1, 'order', '0', 'admin', sysdate(), '', null, '半成品子项');
insert into mom_mbom_item values(3, 1, 1, 2, 20, 1.000000, 0.0100, 2, 4, 'operation', '0', 'admin', sysdate(), '', null, '半成品子项');
insert into mom_mbom_item values(4, 1, 0, 2, 20, 1.000000, 0.0100, 3, 5, 'backflush', '0', 'admin', sysdate(), '', null, '测试投料');
insert into mom_mbom_item values(5, 2, 0, 1, 10, 1.000000, 0.0100, 4, 7, 'operation', '0', 'admin', sysdate(), '', null, '模块用料');
insert into mom_mbom_item values(6, 2, 0, 2, 20, 1.000000, 0.0000, 5, 9, 'backflush', '0', 'admin', sysdate(), '', null, '包装用料');
insert into mom_work_order values(1, 'WO-20260608-001', '智能控制箱试制工单', 4, 1, 1, 2, 50.000000, 0.000000, '台', 'urgent', 'SO-TEST-001', '2026-06-08', '2026-06-10', null, null, 'released', 'admin', sysdate(), '', null, '测试已下达工单');
insert into mom_work_order values(2, 'WO-20260608-002', '标准驱动模块生产工单', 5, 2, 2, 2, 100.000000, 35.000000, '台', 'normal', 'SO-TEST-002', '2026-06-09', '2026-06-12', sysdate(), null, 'running', 'admin', sysdate(), '', null, '测试生产中工单');
insert into mom_work_order values(3, 'WO-20260608-003', '智能控制箱草稿工单', 4, 1, 1, 3, 20.000000, 0.000000, '台', 'normal', null, '2026-06-13', '2026-06-14', null, null, 'draft', 'admin', sysdate(), '', null, '测试草稿工单');
insert into mom_schedule values(1, 'SCH-20260608-001', 1, 2, 3, '2026-06-08 08:00:00', '2026-06-08 12:00:00', 50.000000, 0.000000, 'released', 'admin', sysdate(), '', null, '智能控制箱主体装配排产');
insert into mom_schedule values(2, 'SCH-20260609-001', 2, 4, 3, '2026-06-09 08:00:00', '2026-06-09 13:00:00', 100.000000, 35.000000, 'running', 'admin', sysdate(), '', null, '标准驱动模块装配排产');
insert into mom_schedule values(3, 'SCH-20260613-001', 3, 2, 4, '2026-06-13 08:00:00', '2026-06-13 11:00:00', 20.000000, 0.000000, 'draft', 'admin', sysdate(), '', null, '草稿工单测试排产');
insert into mom_step_report values(1, 2, 2, 4, 7, 3, 35.000000, 1.000000, sysdate(), 'admin', 'confirmed', 'admin', sysdate(), '', null, '测试报工记录');

-- ----------------------------
-- 编码规则
-- ----------------------------
drop table if exists sys_code_rule_record;
drop table if exists sys_code_rule;
create table sys_code_rule (
  rule_id            bigint(20)      not null auto_increment    comment '规则ID',
  rule_code          varchar(64)      not null                   comment '规则编码',
  rule_name          varchar(100)     not null                   comment '规则名称',
  prefix             varchar(32)      default ''                 comment '编码前缀',
  date_format        varchar(32)      default 'yyyyMMdd'         comment '日期格式',
  serial_length      int(4)           not null default 4         comment '流水号位数',
  separator          varchar(8)       default '-'                comment '分隔符',
  reset_period       varchar(16)      not null default 'DAILY'   comment '重置周期',
  current_serial     bigint(20)       default 0                  comment '当前序号',
  last_generate_time datetime                                    comment '最后生成时间',
  status             char(1)          default '0'                comment '状态（0启用 1禁用）',
  create_by          varchar(64)      default ''                 comment '创建者',
  create_time        datetime                                    comment '创建时间',
  update_by          varchar(64)      default ''                 comment '更新者',
  update_time        datetime                                    comment '更新时间',
  remark             varchar(500)     default null               comment '备注',
  primary key (rule_id),
  unique key uk_sys_code_rule_code (rule_code)
) engine=innodb auto_increment=1 comment='编码规则表';

create table sys_code_rule_record (
  record_id          bigint(20)      not null auto_increment    comment '记录ID',
  rule_code          varchar(64)      not null                   comment '规则编码',
  generated_code     varchar(128)     not null                   comment '生成编码',
  create_time        datetime                                    comment '创建时间',
  primary key (record_id),
  unique key uk_sys_code_rule_record_code (rule_code, generated_code)
) engine=innodb auto_increment=1 comment='编码生成记录表';

insert into sys_code_rule values(1, 'MATERIAL', '物料编码', 'MAT', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', sysdate(), '', null, '物料数据编码规则');
insert into sys_code_rule values(2, 'RESOURCE', '资源编码', 'RES', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', sysdate(), '', null, '生产资源编码规则');
insert into sys_code_rule values(3, 'WORK_ORDER', '工单编码', 'WO', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', sysdate(), '', null, '生产工单编码规则');
insert into sys_code_rule values(4, 'FACTORY', '工厂编码', 'FAC', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', sysdate(), '', null, '工厂自动编码规则');
insert into sys_code_rule values(5, 'WORKSHOP', '车间编码', 'WS', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', sysdate(), '', null, '车间自动编码规则');
insert into sys_code_rule values(6, 'LINE', '产线编码', 'LINE', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', sysdate(), '', null, '产线自动编码规则');
insert into sys_code_rule values(7, 'STATION', '工位编码', 'ST', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', sysdate(), '', null, '工位自动编码规则');
insert into sys_code_rule values(8, 'LOCATION', '库位编码', 'LOC', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', sysdate(), '', null, '库位自动编码规则');
insert into sys_code_rule values(9, 'ROUTING', '路线编码', 'RT', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', sysdate(), '', null, '工艺路线自动编码规则');
insert into sys_code_rule values(10, 'OPERATION', '工序编码', 'OP', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', sysdate(), '', null, '工序自动编码规则');
insert into sys_code_rule values(11, 'STEP', '工步编码', 'STEP', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', sysdate(), '', null, '工步自动编码规则');
insert into sys_code_rule values(12, 'PBOM', 'PBOM编码', 'PBOM', 'yyyyMMdd', 4, '-', 'DAILY', 0, null, '0', 'admin', sysdate(), '', null, 'PBOM自动编码规则');
