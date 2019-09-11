#!/usr/bin/env python
# -*- coding: utf-8 -*-

import html
import os
import sys

from django.conf import settings
from django.http import HttpResponse
from django.urls import path
from django.utils.crypto import get_random_string
from django.core.asgi import get_asgi_application


settings.configure(
    DEBUG=(os.environ.get("DEBUG", "") == "1"),
    ALLOWED_HOSTS=["*"],  # Disable host header validation
    ROOT_URLCONF=__name__,  # Make this module the urlconf
    DATABASES = { 'default': {
      'ENGINE': 'django.db.backends.sqlite3',
      'NAME': 'database.db',
    }}
)

def index(request):
    name = request.GET.get("name", "World")
    return HttpResponse(f"Hello, {html.escape(name)}!")

urlpatterns = [
    path("", index),
]

application = get_asgi_application()

if __name__ == "__main__":
    from django.core.management import execute_from_command_line
    execute_from_command_line(sys.argv)
