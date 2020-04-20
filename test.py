import unittest
import os

# Interested only that the software is present. Version isn't important.
def versionOutputLen(input):
    cmd = '{0} --version'.format(input)
    string = os.popen(cmd).read().strip('\n')
    if input != 'vim':
        # vim's output is too verbose. Versions will show when tests are run.
        print(string)
    return len(string.split(' '))

# If any test fails the build fails due to an exit code unittest provides.
class TestVersions(unittest.TestCase):
    def test_Conda(self):
        self.assertEqual(versionOutputLen('conda'), 2)

    def test_Emacs(self):
        self.assertEqual(versionOutputLen('emacs'), 39)

    def test_Git(self):
        self.assertEqual(versionOutputLen('git'), 3)

    def test_java(self):
        self.assertEqual(versionOutputLen('java'), 15)

    def test_Nano(self):
        self.assertEqual(versionOutputLen('nano'), 26)

    def test_Python(self):
        self.assertEqual(versionOutputLen('python'), 2)

    def test_R(self):
        self.assertEqual(versionOutputLen('R'), 51)

    def test_Samtools(self):
        self.assertEqual(versionOutputLen('samtools'), 9)

    def test_Vim(self):
        self.assertEqual(versionOutputLen('vim'), 1005)

if __name__ == '__main__':
    unittest.main()