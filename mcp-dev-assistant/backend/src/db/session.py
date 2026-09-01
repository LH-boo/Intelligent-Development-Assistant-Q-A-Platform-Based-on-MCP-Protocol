#数据库会话搭建
import os
import sys

# 保证直接运行本文件（python src/db/session.py）时能找到 backend 下的模块
BASE_DIR = os.path.abspath(os.path.join(__file__, "../../../"))
sys.path.insert(0, BASE_DIR)

from sqlalchemy import create_engine

from sqlalchemy.orm import sessionmaker

from src.config.settings import settings

# 组装mysql连接url
SQLALCHEMY_DATABASE_URL = (
    f"mysql+pymysql://{settings.MYSQL_USER}:{settings.MYSQL_PASSWORD}"
    f"@{settings.MYSQL_HOST}:{settings.MYSQL_PORT}/{settings.MYSQL_DB}?charset=utf8mb4"
)

engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    pool_pre_ping=True,
    pool_recycle=3600,
    echo=False  # True打印SQL日志，开发调试打开，生产关闭
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    """FastAPI依赖项，获取数据库会话"""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
