import re

from setuptools import find_packages
from setuptools import setup

with open("requirements.txt") as f:
    requirements = f.read().splitlines()

with open("README.md", "r", encoding="utf-8") as f:
    long_description = f.read()
    long_description = re.sub(r"\n!\[.*\]\(.*\)", "", long_description)
    long_description = re.sub(r"\n- \[.*\]\(.*\)", "", long_description)

setup(
    name="package_name",
    version="0.0.1",
    packages=find_packages(),
    include_package_data=True,
    install_requires=requirements,
    python_requires=">=3.9,<3.13",
    entry_points={
        "console_scripts": [
            "package_name = package_name.main:main",
        ],
    },
    description="Placeholder text",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/Meptl",
    classifiers=[],
)
