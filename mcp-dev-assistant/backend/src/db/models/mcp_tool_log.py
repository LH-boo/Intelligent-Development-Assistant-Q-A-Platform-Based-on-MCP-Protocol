#mcp工具调用日志
from datetime import datetime
from sqlalchemy import Integer, String, Text, DateTime, ForeignKey, Float
from sqlalchemy.orm import Mapped, mapped_column
from src.db.base import Base

class McpToolLog(Base):
    __tablename__ = "mcp_tool_log"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    session_id: Mapped[int] = mapped_column(Integer, ForeignKey("chat_session.id"), nullable=False, index=True)
    tool_name: Mapped[str] = mapped_column(String(128), nullable=False)
    tool_input: Mapped[str] = mapped_column(Text, nullable=True)  # json字符串
    tool_output: Mapped[str] = mapped_column(Text, nullable=True) # json字符串
    status: Mapped[str] = mapped_column(String(16), nullable=False) # success / fail
    cost_time: Mapped[float] = mapped_column(Float, nullable=True) # 耗时 秒
    create_time: Mapped[datetime] = mapped_column(DateTime, default=datetime.now)
