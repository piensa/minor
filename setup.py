import sys
from setuptools.command.test import test as TestCommand
from setuptools import setup


class PyTest(TestCommand):
    def finalize_options(self):
        TestCommand.finalize_options(self)
        self.test_args = []
        self.test_suite = True

    def run_tests(self):
        import pytest
        errno = pytest.main(self.test_args)
        sys.exit(errno)


setup(
    name='swing',
    version='0.1',
    url='http://github.com/piensa/swing',
    license='MIT',
    author='Ariel Nunez',
    author_email='ariel@piensa.co',
    description='swing',
    long_description=open('README.md').read() + '\n\n' + open('CHANGELOG.md').read(),
    tests_require=['pytest-django', 'pytest', 'coveralls', 'flake8'],
    cmdclass={'test': PyTest},
    py_modules=['swing'],
    classifiers=[
        'Development Status :: 1 - Planning',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: Implementation :: PyPy',
        'Programming Language :: Python :: Implementation :: CPython',
    ],
)
