import sys
from pathlib import Path
# 将 backend 目录加入模块搜索路径
sys.path.append(str(Path(__file__).parent.parent))

from src.config.settings import DB_CONFIG
import pymysql

if __name__ == "__main__":
    print("DB_CONFIG:", DB_CONFIG)
    try:
        conn = pymysql.connect(**DB_CONFIG)
        print("✅ MySQL连接成功")
        conn.close()
    except Exception as e:
        print(f"❌ 失败: {e}")
