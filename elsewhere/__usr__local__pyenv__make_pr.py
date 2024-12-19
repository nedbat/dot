import hashlib
import os
import re
import sys
import subprocess
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

def run_git_command(args):
    subprocess.run(["git"] + args, check=True)

def update_pyenv_file(old_version, new_version):
    pyenv_path = Path("plugins/python-build/share/python-build")
    old_file = pyenv_path / str(old_version)
    new_file = pyenv_path / str(new_version)
    
    if not old_file.exists():
        raise FileNotFoundError(f"Source file {old_file} not found")
    
    # Basic file update as before
    content = old_file.read_text()
    content = content.replace(str(old_version), str(new_version))
    
    old_vdir = re.sub(r"[abc]\d+", "", old_version)
    new_vdir = re.sub(r"[abc]\d+", "", new_version)
    checksums = get_python_checksums(new_version, new_vdir)

    # Update checksums and URLs
    for filename, sha256 in checksums.items():
        content = re.sub(
            f"python/{old_vdir}/{filename}#([0-9a-f]){{64}}",
            f"python/{new_vdir}/{filename}#{sha256}",
            content,
        )
    
    # Write and update the main file
    if is_prerelease(new_version):
        run_git_command(["mv", str(old_file), str(new_file)])
    new_file.write_text(content)
    run_git_command(["add", str(new_file)])

    # Handle t-suffix files (for both stable and pre-release versions)
    old_t_file = pyenv_path / f"{old_version}t"
    new_t_file = pyenv_path / f"{new_version}t"
    if old_t_file.exists():
        content = old_t_file.read_text()
        content = content.replace(str(old_version), str(new_version))
        
        if is_prerelease(new_version):
            run_git_command(["mv", str(old_t_file), str(new_t_file)])
        new_t_file.write_text(content)
        run_git_command(["add", str(new_t_file)])

def is_prerelease(version):
    return bool(re.search(r"(a|b|rc)\d+", version))

def get_previous_version(version, pyenv_path=Path("plugins/python-build/share/python-build")):
    PRERELEASE_ORDER = {"rc": ["b", "a"], "b": ["a"], "a": []}
    
    # Stricter version number validation - capture the full version structure
    match = re.match(r"^(\d+\.\d+\.)(\d+)(a|b|rc)?(\d+)?$", version)
    if not match:
        raise ValueError(f"Invalid version format: {version}")
    
    prefix, patch, prerelease, num = match.groups()
    patch_num = int(patch)
    num = int(num) if num else None
    
    # Special handling for .0 releases - check this first
    if patch_num == 0 and not prerelease:
        version_base = prefix + patch
        for pre_type in ["rc", "b", "a"]:
            pattern = f"{version_base}{pre_type}*"
            pre_files = list(pyenv_path.glob(pattern))
            if pre_files:
                latest = max(pre_files, key=lambda p: 
                    int(re.search(rf"{pre_type}(\d+)$", p.name).group(1)))
                return latest.name
        raise ValueError(f"Cannot find previous version for {version}")
    
    if prerelease:
        # Try decrementing the number first
        if num > 1:
            return f"{prefix}{patch}{prerelease}{num-1}"
            
        # Look for previous pre-release type
        if prerelease in PRERELEASE_ORDER:
            for prev_type in PRERELEASE_ORDER[prerelease]:
                pattern = f"{prefix}{patch}{prev_type}*"
                prev_files = list(pyenv_path.glob(pattern))
                if prev_files:
                    latest = max(prev_files, key=lambda p: 
                        int(re.search(rf"{prev_type}(\d+)$", p.name).group(1)))
                    return latest.name
        
        raise ValueError(f"Cannot find previous version for {version}")
    
    # For normal versions
    return f"{prefix}{patch_num-1}"

if __name__ == "__main__":
    # TODO: the -t files have to change also: https://github.com/pyenv/pyenv/pull/3135
    if len(sys.argv) < 2:
        print("Usage: make_pr.py VERSION [VERSION...]")
        sys.exit(1)
    
    new_versions = sys.argv[1:]
    versions_added = []

    for new_version in new_versions:
        try:
            old_version = get_previous_version(new_version)
            if is_prerelease(new_version):
                print(f"Replacing {old_version} with {new_version}")
            else:
                print(f"Adding {new_version} (previous: {old_version})")
            update_pyenv_file(old_version, new_version)
            versions_added.append(new_version)
        except (ValueError, FileNotFoundError) as e:
            print(f"Error processing {new_version}: {e}")
            sys.exit(1)

    if versions_added:
        run_git_command(["commit", "-m", f"Add CPython {', '.join(versions_added)}"])
        print(f"Created commit for Python {', '.join(versions_added)}")
