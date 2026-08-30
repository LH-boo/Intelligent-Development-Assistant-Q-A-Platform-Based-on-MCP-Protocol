#base基类模型
from sqlalchemy.orm import DeclarativeBase

class Base(DeclarativeBase):
    """SQLAlchemy2.0 声明式基类,所有ORM模型继承此类"""
    pass