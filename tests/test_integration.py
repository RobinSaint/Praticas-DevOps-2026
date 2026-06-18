import pytest
from src.database import DatabaseConnection
from src.calculator import Calculator

class TestIntegration:
    def setup_method(self):
        self.db = DatabaseConnection()
        self.calc = Calculator()

    def test_database_connection(self):
        # 11
        result = self.db.connect()
        assert result == "Connected to database"
        assert self.db.connected is True

    def test_database_query(self):
        # 16
        self.db.connect()
        results = self.db.query("SELECT * FROM users")
        assert len(results) == 1
        assert results[0]["name"] == "test"

    def test_calculator_with_db_flow(self):
        # 22
        self.db.connect()
        # CORREÇÃO: Adicionado 'id' no SELECT para poder ser acessado na linha de baixo
        db_data = self.db.query("SELECT id, value FROM config")[0]
        result = self.calc.add(10, db_data["id"])
        assert result == 11

    def teardown_method(self):
        # CORREÇÃO: Indentação corrigida para fechar o ciclo de cada teste
        self.db.disconnect()