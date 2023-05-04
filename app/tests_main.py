import unittest
from demo import app

class Tests(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()

    def test_app_endpoint(self):

        response = self.app.get("/")
        # print (response.data)
        self.assertEqual(
            response.data,
            b'<p>Hello, World!</p>',
        )
        self.assertEqual(response.status_code, 200)

if __name__ == '__main__':
    unittest.main()
