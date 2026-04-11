import sys, json
from graphify.build import build_from_json
from graphify.cluster import cluster, score_all
from graphify.analyze import god_nodes, surprising_connections, suggest_questions
from graphify.report import generate
from graphify.export import to_json
from pathlib import Path

with open('graphify-out/.graphify_extract.json', 'r', encoding='utf-8') as f:
    extraction = json.load(f)
try:
    with open('graphify-out/.graphify_detect.json', 'r', encoding='utf-16') as f:
        detection = json.load(f)
except:
    with open('graphify-out/.graphify_detect.json', 'r', encoding='utf-8') as f:
        detection = json.load(f)

G = build_from_json(extraction)
communities = cluster(G)
cohesion = score_all(G, communities)
tokens = {'input': extraction.get('input_tokens', 0), 'output': extraction.get('output_tokens', 0)}
gods = god_nodes(G)
surprises = surprising_connections(G, communities)
labels = {cid: 'Community ' + str(cid) for cid in communities}
questions = suggest_questions(G, communities, labels)

report = generate(G, communities, cohesion, labels, gods, surprises, detection, tokens, '.', suggested_questions=questions)
with open('graphify-out/GRAPH_REPORT.md', 'w', encoding='utf-8') as f:
    f.write(report)
to_json(G, communities, 'graphify-out/graph.json')

analysis = {
    'communities': {str(k): v for k, v in communities.items()},
    'cohesion': {str(k): v for k, v in cohesion.items()},
    'gods': gods,
    'surprises': surprises,
    'questions': questions,
}
with open('graphify-out/.graphify_analysis.json', 'w', encoding='utf-8') as f:
    json.dump(analysis, f, indent=2)

if G.number_of_nodes() == 0:
    print('ERROR: Graph is empty')
    sys.exit(1)
print(f'Graph: {G.number_of_nodes()} nodes, {G.number_of_edges()} edges, {len(communities)} communities')
