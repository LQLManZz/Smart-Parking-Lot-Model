# Graph Report - .  (2026-04-10)

## Corpus Check
- Corpus is ~6,279 words - fits in a single context window. You may not need a graph.

## Summary
- 12 nodes · 13 edges · 3 communities detected
- Extraction: 62% EXTRACTED · 31% INFERRED · 8% AMBIGUOUS · INFERRED: 4 edges (avg confidence: 0.9)
- Token cost: 0 input · 0 output

## God Nodes (most connected - your core abstractions)
1. `Laser Sensor Main Logic` - 5 edges
2. `OTA Connection Implementation` - 3 edges
3. `PlatformIO Configuration (esp32_parkinglot)` - 2 edges
4. `OTA Connection Header` - 2 edges
5. `I2S Connection Verilog Module` - 1 edges
6. `Parking Lot CAD Drawing` - 1 edges

## Surprising Connections (you probably didn't know these)
- `I2S Connection Verilog Module` --semantically_similar_to--> `Laser Sensor Main Logic`  [AMBIGUOUS] [semantically similar]
  verilog/i2s_connection.v → src/laser_sensor.cpp
- `PlatformIO Configuration (esp32_parkinglot)` --references--> `Laser Sensor Main Logic`  [INFERRED]
  platformio.ini → src/laser_sensor.cpp
- `Laser Sensor Main Logic` --conceptually_related_to--> `Parking Lot CAD Drawing`  [INFERRED]
  src/laser_sensor.cpp → CAD/ParkingLot_Page__.svg
- `PlatformIO Configuration (esp32_parkinglot)` --references--> `OTA Connection Implementation`  [INFERRED]
  platformio.ini → src/ota_connection.cpp
- `Laser Sensor Main Logic` --references--> `OTA Connection Header`  [EXTRACTED]
  src/laser_sensor.cpp → include/ota_connection.h

## Communities

### Community 0 - "System Integration & Configuration"
Cohesion: 0.47
Nodes (6): I2S Connection Verilog Module, Laser Sensor Main Logic, OTA Connection Header, OTA Connection Implementation, Parking Lot CAD Drawing, PlatformIO Configuration (esp32_parkinglot)

### Community 1 - "OTA Update Service"
Cohesion: 1.0
Nodes (0): 

### Community 2 - "Laser Sensor Firmware"
Cohesion: 0.67
Nodes (0): 

## Ambiguous Edges - Review These
- `I2S Connection Verilog Module` → `Laser Sensor Main Logic`  [AMBIGUOUS]
  verilog/i2s_connection.v · relation: semantically_similar_to

## Knowledge Gaps
- **2 isolated node(s):** `I2S Connection Verilog Module`, `Parking Lot CAD Drawing`
  These have ≤1 connection - possible missing edges or undocumented components.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `I2S Connection Verilog Module` and `Laser Sensor Main Logic`?**
  _Edge tagged AMBIGUOUS (relation: semantically_similar_to) - confidence is low._
- **Are the 3 inferred relationships involving `Laser Sensor Main Logic` (e.g. with `OTA Connection Implementation` and `PlatformIO Configuration (esp32_parkinglot)`) actually correct?**
  _`Laser Sensor Main Logic` has 3 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `OTA Connection Implementation` (e.g. with `Laser Sensor Main Logic` and `PlatformIO Configuration (esp32_parkinglot)`) actually correct?**
  _`OTA Connection Implementation` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `PlatformIO Configuration (esp32_parkinglot)` (e.g. with `Laser Sensor Main Logic` and `OTA Connection Implementation`) actually correct?**
  _`PlatformIO Configuration (esp32_parkinglot)` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `I2S Connection Verilog Module`, `Parking Lot CAD Drawing` to the rest of the system?**
  _2 weakly-connected nodes found - possible documentation gaps or missing edges._