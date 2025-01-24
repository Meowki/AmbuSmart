# declarative_base() 函数返回的 Base 类是 SQLAlchemy 中的一个基类，
# 它用于定义 ORM 模型类。所有的数据库表模型（如 Patient）都应该继承 Base，
# 这样它们就能与数据库表关联并进行各种操作（增、删、改、查）。
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()