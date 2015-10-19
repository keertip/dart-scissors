// Copyright 2015 Google Inc. All Rights Reserved.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
library scissors.name_fragment;

final RegExp _INTERPOLATION = new RegExp(r'(?:\{\{.*?\}\})+', multiLine: true);

/// Parses classes and class fragments out of a class attribute value.
List<Pattern> parseClassPatterns(String classAttributeValue) {
  if (classAttributeValue == null) return [];

  return _getFragmentableClasses(classAttributeValue).map((name) {
    if (name.contains("{{")) {
      return new RegExp('^' + name.replaceAll(_INTERPOLATION, ".*?") + r'$',
          multiLine: true);
    } else {
      return name;
    }
  }).toList(growable: false);
}

/// Matches `a-class`, `a-fragmented-{{mustache}}-class`
final _WORD = new RegExp(r'([\w-_]+|\{\{.*?\}\})+', multiLine: true);

/// Chunks a class attribute value into fragmentable class words.
/// For instance, returns `["a", "b{{c d}}"]` out of `"a b{{c d}}"`.
Iterable<String> _getFragmentableClasses(String cls) =>
    _WORD.allMatches(cls).map((m) => m[0]);
