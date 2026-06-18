class DatabaseConnection:
    def __init__(self):
        self.connected = False

    def connect(self):
        self.connected = True
        return "Connected to database"

    def disconnect(self):
        self.connected = False
        return "Disconnected"

    def query(self, sql: str)-> list:
        if not self.connected:
            raise ConnectionError("Not connected to database")
        return [{"id": 1, "name": "test"}]