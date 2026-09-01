import os
from dataclasses import dataclass
from dotenv import load_dotenv
# __file__ 当前settings.py的物理路径
BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ENV_PATH = os.path.join(BASE_DIR, ".env")

# 加载.env，使用绝对路径，不受运行目录影响
load_dotenv(ENV_PATH)

MYSQL_HOST = os.getenv("MYSQL_HOST", "127.0.0.1")
MYSQL_PORT = int(os.getenv("MYSQL_PORT", 3306))
MYSQL_USER = os.getenv("MYSQL_USER")
MYSQL_PASSWORD = os.getenv("MYSQL_PASSWORD")
MYSQL_DB = os.getenv("MYSQL_DB")

DB_CONFIG = {
    "host": MYSQL_HOST,
    "port": MYSQL_PORT,
    "user": MYSQL_USER,
    "password": MYSQL_PASSWORD,
    "database": MYSQL_DB,
}
API_KEY_A_LI = os.getenv("LLM_API_KEY_A_LI")

# 统一的settings对象，供 session.py 等模块按属性方式访问
# 用 dataclass 而不是 SimpleNamespace，让 IDE 能识别出每个字段的具体类型（不再显示 any）
@dataclass
class Settings:
    MYSQL_HOST: str
    MYSQL_PORT: int
    MYSQL_USER: str
    MYSQL_PASSWORD: str
    MYSQL_DB: str


settings = Settings(
    MYSQL_HOST=MYSQL_HOST,
    MYSQL_PORT=MYSQL_PORT,
    MYSQL_USER=MYSQL_USER,
    MYSQL_PASSWORD=MYSQL_PASSWORD,
    MYSQL_DB=MYSQL_DB,
)