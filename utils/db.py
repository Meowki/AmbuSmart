from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from utils.config import Config
from utils.models import Base

class Database:
    def __init__(self):
        self.engine = create_engine(Config.DATABASE_URL, echo=True)
        self.SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=self.engine)
        self.create_tables()

    def create_tables(self):
        Base.metadata.create_all(bind=self.engine)

    def get_db(self):
        db = self.SessionLocal()
        try:
            yield db
        finally:
            db.close()

    def test_connection(self):
        try:
            with self.engine.connect() as connection:
                result = connection.execute("SELECT 1")
                if result.scalar() == 1:
                    print("数据库连接成功！")
                else:
                    print("数据库连接失败！")
        except Exception as e:
            print(f"连接数据库时发生错误: {e}") 