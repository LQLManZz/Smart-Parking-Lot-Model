import sys, json
from graphify.extract import collect_files, extract
from pathlib import Path

code_files = [
    Path('include/ota_connection.h'),
    Path('src/laser_sensor.cpp'),
    Path('src/ota_connection.cpp')
]

if code_files:
    result = extract(code_files)
    with open('graphify-out/.graphify_ast.json', 'w') as f:
        json.dump(result, f, indent=2)
    print(f'AST: {len(result["nodes"])} nodes, {len(result["edges"])} edges')
else:
    with open('graphify-out/.graphify_ast.json', 'w') as f:
        json.dump({'nodes':[],'edges':[],'input_tokens':0,'output_tokens':0}, f)
    print('No code files - skipping AST extraction')
