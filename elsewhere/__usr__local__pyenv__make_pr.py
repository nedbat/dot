import hashlib
import os
import re
import sys
from inspect import cleandoc
from pathlib import Path

import requests

def get_python_checksums(version, vdir):
    base_url = f"https://www.python.org/ftp/python/{vdir}"
    files = [
        f"Python-{version}.tar.xz",
        f"Python-{version}.tgz"
    ]
    
    checksums = {}
    for file in files:
        response = requests.get(f"{base_url}/{file}")
        response.raise_for_status()
        content = response.content
        checksums[file] = hashlib.sha256(content).hexdigest()
    return checksums

def update_pyenv_file(old_version, new_version):
    pyenv_path = Path("plugins/python-build/share/python-build")
    old_file = pyenv_path / str(old_version)
    new_file = pyenv_path / str(new_version)
    
    if not old_file.exists():
        raise FileNotFoundError(f"Source file {old_file} not found")
        
    content = old_file.read_text()
    
    content = content.replace(str(old_version), str(new_version))
    
    old_vdir = re.sub(r"[abc]\d+", "", old_version)
    new_vdir = re.sub(r"[abc]\d+", "", new_version)
    checksums = get_python_checksums(new_version, new_vdir)

    # Update checksums and URLs
    for filename, sha256 in checksums.items():
        content = re.sub(
            # old filename has already been changed to new filename...
            f"python/{old_vdir}/{filename}#([0-9a-f]){{64}}",
            f"python/{new_vdir}/{filename}#{sha256}",
            content,
        )
    
    tmp = Path(f"/tmp/{new_version}")
    tmp.write_text(content)

    print(cleandoc(f"""
        # Created {tmp} with updated checksums

        # Check the changes:
        diff {old_file} {tmp}

        # Put the file in place:
        git mv {old_file} {new_file}
        cp {tmp} {new_file}
        git commit -am "Add CPython {new_version}"
    """))

if __name__ == "__main__":
    old_version, new_version = sys.argv[1:]
    update_pyenv_file(old_version, new_version)
