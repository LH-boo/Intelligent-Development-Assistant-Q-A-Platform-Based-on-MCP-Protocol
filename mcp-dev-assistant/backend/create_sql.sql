-- 创建数据库（如未创建）
CREATE DATABASE IF NOT EXISTS mcp_dev_assistant DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE mcp_dev_assistant;

-- 1. 用户表 user
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(64) NOT NULL COMMENT '用户名',
  `password_hash` varchar(256) NOT NULL COMMENT '密码哈希',
  `role` varchar(16) NOT NULL DEFAULT 'user' COMMENT '角色：admin/user',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 2. 对话会话表 chat_session
DROP TABLE IF EXISTS `chat_session`;
CREATE TABLE `chat_session` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '会话ID',
  `user_id` int NOT NULL COMMENT '所属用户id',
  `title` varchar(256) DEFAULT NULL COMMENT '会话标题',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `fk_chat_session_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='对话会话表';

-- 3. 对话消息表 chat_message
DROP TABLE IF EXISTS `chat_message`;
CREATE TABLE `chat_message` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `session_id` int NOT NULL COMMENT '会话id',
  `role` varchar(16) NOT NULL COMMENT '角色 user / assistant',
  `content` text NOT NULL COMMENT '消息内容',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_session_id` (`session_id`),
  CONSTRAINT `fk_chat_msg_session` FOREIGN KEY (`session_id`) REFERENCES `chat_session` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='对话消息明细表';

-- 4. MCP工具调用日志 mcp_tool_log
DROP TABLE IF EXISTS `mcp_tool_log`;
CREATE TABLE `mcp_tool_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `session_id` int NOT NULL COMMENT '关联会话ID',
  `tool_name` varchar(128) NOT NULL COMMENT '工具名称',
  `tool_input` text DEFAULT NULL COMMENT '调用入参JSON',
  `tool_output` text DEFAULT NULL COMMENT '工具返回JSON',
  `status` varchar(16) NOT NULL COMMENT '状态 success / fail',
  `cost_time` float DEFAULT NULL COMMENT '执行耗时(秒)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '调用时间',
  PRIMARY KEY (`id`),
  KEY `idx_session_id` (`session_id`),
  CONSTRAINT `fk_mcplog_session` FOREIGN KEY (`session_id`) REFERENCES `chat_session` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MCP工具调用日志表';

-- 5. RAG知识库文档元数据 knowledge_doc
DROP TABLE IF EXISTS `knowledge_doc`;
CREATE TABLE `knowledge_doc` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '文档id',
  `user_id` int NOT NULL COMMENT '上传用户id',
  `filename` varchar(256) NOT NULL COMMENT '原始文件名',
  `file_type` varchar(32) NOT NULL COMMENT '文件类型 pdf/md/txt',
  `logic_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0未删 1已删',
  `upload_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `fk_know_doc_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='知识库文档元数据表';

-- 6. 文档切片表 knowledge_chunk
DROP TABLE IF EXISTS `knowledge_chunk`;
CREATE TABLE `knowledge_chunk` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '切片主键',
  `doc_id` int NOT NULL COMMENT '关联文档id',
  `chunk_text` text NOT NULL COMMENT '切片文本内容',
  `chunk_index` int NOT NULL COMMENT '切片序号',
  `vector_id` varchar(128) DEFAULT NULL COMMENT 'Chroma向量库ID',
  PRIMARY KEY (`id`),
  KEY `idx_doc_id` (`doc_id`),
  CONSTRAINT `fk_chunk_doc` FOREIGN KEY (`doc_id`) REFERENCES `knowledge_doc` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文档切片向量映射表';

-- 插入一条测试管理员账号，密码哈希这里仅示例，实际项目用bcrypt生成
INSERT INTO `user` (`username`, `password_hash`, `role`) VALUES ('admin', '$2b$12$xxxx', 'admin');

/*
表名	用途
user	存储账号密码、角色
chat_session	每一次对话会话（会话标题、所属用户）
chat_message	会话下一条条用户 / AI 消息
mcp_tool_log	答辩重点，记录 MCP 工具调用：工具名、入参、出参、耗时、成败
knowledge_doc	上传的文档：文件名、类型、逻辑删除标记
knowledge_chunk	文档切分后的片段，保存文本和 Chroma 向量 ID
*/