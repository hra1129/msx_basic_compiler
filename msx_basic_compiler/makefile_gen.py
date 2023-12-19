import xml.etree.ElementTree as ET
import re

tree = ET.parse('msx_basic_compiler.vcxproj')
root = tree.getroot()
files = ""
for t in root.findall('./{http://schemas.microsoft.com/developer/msbuild/2003}ItemGroup/{http://schemas.microsoft.com/developer/msbuild/2003}ClCompile'):
    file = t.attrib['Include']
    file = re.sub(r"\\", "/", file)
    files += f"\t{file} \\\n"

with open("Makefile", "r") as f:
    makefile = f.read()
makefile = re.sub(r"SRCS =(.*)?\n\nOBJS",f"SRCS ={files}\nOBJS",makefile,0,re.MULTILINE | re.DOTALL)
with open("Makefile", "w") as f:
    f.write(makefile)
