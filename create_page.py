from CTFd import create_app
from CTFd.models import Pages, db

app = create_app()
with app.app_context():
    page = Pages(
        title="Test Page",
        route="test",
        content="This is a test page created via script.",
        draft=False,
        hidden=False,
        auth_required=False,
        format="markdown"
    )
    db.session.add(page)
    db.session.commit()
    print(f"Page created with ID: {page.id}")
