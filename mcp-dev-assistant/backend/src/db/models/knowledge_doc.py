#rag知识库文档
from datetime import datetime
from sqlalchemy import Integer, String, DateTime, ForeignKey, Boolean
from sqlalchemy.orm import Mapped, mapped_column
from src.db.base import Base

class KnowledgeDoc(Base):
    __tablename__ = "knowledge_doc"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(Integer, ForeignKey("user.id"), nullable=False, index=True)
    filename: Mapped[str] = mapped_column(String(256), nullable=False)
    file_type: Mapped[str] = mapped_column(String(32), nullable=False) # pdf / md / txt
    logic_delete: Mapped[bool] = mapped_column(Boolean, default=False) # 逻辑删除标记
    upload_time: Mapped[datetime] = mapped_column(DateTime, default=datetime.now)
