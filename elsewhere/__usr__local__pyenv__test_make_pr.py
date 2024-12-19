from make_pr import is_prerelease, get_previous_version
import pytest

@pytest.mark.parametrize("version,expected", [
    ("3.10.0a1", True),
    ("3.10.0b2", True),
    ("3.10.0rc3", True),
    ("3.10.0", False),
    ("3.9.7", False),
    ("3.8.12", False),
])
def test_is_prerelease(version, expected):
    assert is_prerelease(version) == expected

@pytest.mark.parametrize("version,expected", [
    ("3.11.10", "3.11.9"),
    ("3.11.2", "3.11.1"),
    ("3.11.0b2", "3.11.0b1"),
    ("3.11.0rc2", "3.11.0rc1"),
    ("3.11.0a3", "3.11.0a2"),
])
def test_get_previous_version(version, expected):
    assert get_previous_version(version) == expected

def test_get_previous_version_dot_zero(tmp_path):
    # Create a mock RC file
    (tmp_path / "3.11.0rc4").touch()
    assert get_previous_version("3.11.0", pyenv_path=tmp_path) == "3.11.0rc4"

def test_get_previous_version_dot_zero_not_found(tmp_path):
    with pytest.raises(ValueError, match="Cannot find previous version"):
        get_previous_version("3.11.0", pyenv_path=tmp_path)

@pytest.mark.parametrize("version", [
    "3",
    "invalid",
    "3.11.0.0",
])
def test_get_previous_version_invalid(version):
    with pytest.raises(ValueError):
        get_previous_version(version)

def test_get_previous_version_prerelease_transition(tmp_path):
    # Create mock files
    (tmp_path / "3.11.0b3").touch()
    (tmp_path / "3.11.0b2").touch()
    (tmp_path / "3.11.0a2").touch()
    
    # rc1 should find b3
    assert get_previous_version("3.11.0rc1", pyenv_path=tmp_path) == "3.11.0b3"
    # b1 should find a2
    assert get_previous_version("3.11.0b1", pyenv_path=tmp_path) == "3.11.0a2"
    
    # Should raise when no previous type exists
    with pytest.raises(ValueError):
        get_previous_version("3.11.0a1", pyenv_path=tmp_path)
