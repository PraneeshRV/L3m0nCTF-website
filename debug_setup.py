from CTFd import create_app
from CTFd.utils import get_config
from CTFd.utils.config import is_setup

app = create_app()
with app.app_context():
    setup_val = get_config("setup")
    print(f"Setup Config Value: '{setup_val}'")
    print(f"Setup Config Type: {type(setup_val)}")
    print(f"Is Setup: {is_setup()}")
