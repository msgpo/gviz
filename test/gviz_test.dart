// Copyright (c) 2017, Kevin Moore. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:gviz/gviz.dart';
import 'package:test/test.dart';

void main() {
  test('adding the same node twice should fail', () {
    var graph = new Graph()
      ..addNode('solo');

    expect(() => graph.addNode('solo'), throwsArgumentError);
  });

  test('empty', () {
    var graph = new Graph();
    expect(graph.toString(), 'digraph the_graph {\n}\n');
  });

  test('one node, one edge', () {
    var graph = new Graph()
      ..addNode('solo')
      ..addEdge('solo', 'solo');

    expect(graph.toString(), '''digraph the_graph {

  solo;
  solo -> solo;
}
''');
  });

  test('handle keywords, numbers, and characters', () {
    var graph = new Graph(
        name: 'lib_graph',
        nodeProperties: {'fontname': 'Source Code Pro'},
        edgeProperties: {'fontname': 'Helvetica', 'fontcolor': 'gray'});

    var values = {
      'edge': 'keyword',
      'node': 'keyword',
      '42': 'starts with number',
      '_5fine': 'no special characters',
      '"quotes"': 'contains double quotes',
      "'quotes'": 'contains single quotes',
      'cool\nbeans': 'contains a newline'
    };

    var lastNode = values.keys.last;
    values.forEach((node, description) {
      graph.addNode(node, properties: {'xlabel': description});
      graph.addEdge(node, lastNode);
      lastNode = node;
    });

    expect(graph.toString(), r'''digraph lib_graph {
  node [fontname="Source Code Pro"];
  edge [fontname=Helvetica, fontcolor=gray];

  "edge" [xlabel=keyword];
  "edge" -> "cool
beans";

  "node" [xlabel=keyword];
  "node" -> "edge";

  "42" [xlabel="starts with number"];
  "42" -> "node";

  _5fine [xlabel="no special characters"];
  _5fine -> "42";

  "\"quotes\"" [xlabel="contains double quotes"];
  "\"quotes\"" -> _5fine;

  "'quotes'" [xlabel="contains single quotes"];
  "'quotes'" -> "\"quotes\"";

  "cool
beans" [xlabel="contains a newline"];
  "cool
beans" -> "'quotes'";
}
''');
  });
}
