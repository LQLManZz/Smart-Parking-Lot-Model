import sys, json
from pathlib import Path

with open('graphify-out/.graphify_ast.json', 'r') as f:
    ast = json.load(f)
with open('graphify-out/.graphify_semantic.json', 'r') as f:
    sem = json.load(f)

seen = {n['id'] for n in ast['nodes']}
merged_nodes = list(ast['nodes'])
for n in sem['nodes']:
    if n['id'] not in seen:
        merged_nodes.append(n)
        seen.add(n['id'])

merged_edges = ast['edges'] + sem['edges']
merged_hyperedges = sem.get('hyperedges', [])
merged = {
    'nodes': merged_nodes,
    'edges': merged_edges,
    'hyperedges': merged_hyperedges,
    'input_tokens': sem.get('input_tokens', 0),
    'output_tokens': sem.get('output_tokens', 0),
}
with open('graphify-out/.graphify_extract.json', 'w') as f:
    json.dump(merged, f, indent=2)

total = len(merged_nodes)
edges = len(merged_edges)
print(f'Merged: {total} nodes, {edges} edges ({len(ast["nodes"])} AST + {len(sem["nodes"])} semantic)')
