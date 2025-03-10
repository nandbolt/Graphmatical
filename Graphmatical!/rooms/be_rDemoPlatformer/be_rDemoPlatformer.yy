{
  "resourceType": "GMRoom",
  "resourceVersion": "1.0",
  "name": "be_rDemoPlatformer",
  "isDnd": false,
  "volume": 1.0,
  "parentRoom": null,
  "views": [
    {"inherit":false,"visible":false,"xview":0,"yview":0,"wview":1366,"hview":768,"xport":0,"yport":0,"wport":1366,"hport":768,"hborder":32,"vborder":32,"hspeed":-1,"vspeed":-1,"objectId":null,},
    {"inherit":false,"visible":false,"xview":0,"yview":0,"wview":1366,"hview":768,"xport":0,"yport":0,"wport":1366,"hport":768,"hborder":32,"vborder":32,"hspeed":-1,"vspeed":-1,"objectId":null,},
    {"inherit":false,"visible":false,"xview":0,"yview":0,"wview":1366,"hview":768,"xport":0,"yport":0,"wport":1366,"hport":768,"hborder":32,"vborder":32,"hspeed":-1,"vspeed":-1,"objectId":null,},
    {"inherit":false,"visible":false,"xview":0,"yview":0,"wview":1366,"hview":768,"xport":0,"yport":0,"wport":1366,"hport":768,"hborder":32,"vborder":32,"hspeed":-1,"vspeed":-1,"objectId":null,},
    {"inherit":false,"visible":false,"xview":0,"yview":0,"wview":1366,"hview":768,"xport":0,"yport":0,"wport":1366,"hport":768,"hborder":32,"vborder":32,"hspeed":-1,"vspeed":-1,"objectId":null,},
    {"inherit":false,"visible":false,"xview":0,"yview":0,"wview":1366,"hview":768,"xport":0,"yport":0,"wport":1366,"hport":768,"hborder":32,"vborder":32,"hspeed":-1,"vspeed":-1,"objectId":null,},
    {"inherit":false,"visible":false,"xview":0,"yview":0,"wview":1366,"hview":768,"xport":0,"yport":0,"wport":1366,"hport":768,"hborder":32,"vborder":32,"hspeed":-1,"vspeed":-1,"objectId":null,},
    {"inherit":false,"visible":false,"xview":0,"yview":0,"wview":1366,"hview":768,"xport":0,"yport":0,"wport":1366,"hport":768,"hborder":32,"vborder":32,"hspeed":-1,"vspeed":-1,"objectId":null,},
  ],
  "layers": [
    {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"CollisionTiles","tilesetId":{"name":"be_tsCollision","path":"tilesets/be_tsCollision/be_tsCollision.yy",},"x":0,"y":0,"tiles":{"TileDataFormat":1,"SerialiseWidth":20,"SerialiseHeight":12,"TileCompressedData":[
-21,1,-18,-2147483648,-2,1,-16,-2147483648,4,0,-2147483648,1,1,-3,-2147483648,1,0,-7,-2147483648,1,
0,-4,-2147483648,5,0,-2147483648,1,1,-2147483648,-4,0,-7,-2147483648,-3,0,7,-2147483648,0,-2147483648,1,
1,-2147483648,-2147483648,-3,0,-7,-2147483648,-5,0,4,-2147483648,1,1,-2147483648,-3,0,-3,-2147483648,-3,1,
-2,-2147483648,5,0,-2147483648,-2147483648,0,-2147483648,-3,1,-6,-2147483648,-4,1,-3,0,1,-2147483648,-3,0,
-3,1,-3,0,-2,-2147483648,-5,1,3,0,-2147483648,-2147483648,-3,0,-4,1,-3,0,1,-2147483648,
-6,1,1,0,-5,-2147483648,-4,1,3,0,-2147483648,-2147483648,-7,1,1,0,-5,-2147483648,-23,1,
],},"visible":false,"depth":0,"userdefinedDepth":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritVisibility":true,"inheritSubLayers":true,"gridX":32,"gridY":32,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"WaterTiles","tilesetId":{"name":"be_tsPWater","path":"tilesets/be_tsPWater/be_tsPWater.yy",},"x":0,"y":0,"tiles":{"TileDataFormat":1,"SerialiseWidth":20,"SerialiseHeight":12,"TileCompressedData":[
-160,-2147483648,-20,2,-60,1,],},"visible":true,"depth":100,"userdefinedDepth":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritVisibility":true,"inheritSubLayers":true,"gridX":32,"gridY":32,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Instances","instances":[],"visible":true,"depth":200,"userdefinedDepth":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritVisibility":true,"inheritSubLayers":true,"gridX":8,"gridY":8,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"GroundInstances","instances":[],"visible":true,"depth":300,"userdefinedDepth":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritVisibility":true,"inheritSubLayers":true,"gridX":8,"gridY":8,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"WorldTiles","tilesetId":{"name":"be_tsBPWorld","path":"tilesets/be_tsBPWorld/be_tsBPWorld.yy",},"x":0,"y":0,"tiles":{"TileDataFormat":1,"SerialiseWidth":20,"SerialiseHeight":12,"TileCompressedData":[
-21,1,-18,0,-2,1,-18,0,-2,1,-18,0,-2,1,-18,0,-2,1,-18,0,
-2,1,-7,0,-3,1,-7,0,-3,1,-6,0,-4,1,-7,0,-3,1,-5,0,
-5,1,-6,0,-4,1,-4,0,-6,1,-6,0,-4,1,-3,0,-7,1,-6,0,
-23,1,],},"visible":true,"depth":400,"userdefinedDepth":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritVisibility":true,"inheritSubLayers":true,"gridX":32,"gridY":32,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRBackgroundLayer","resourceVersion":"1.0","name":"Background","spriteId":null,"colour":4293643911,"x":0,"y":0,"htiled":false,"vtiled":false,"hspeed":0.0,"vspeed":0.0,"stretch":false,"animationFPS":15.0,"animationSpeedType":0,"userdefinedAnimFPS":false,"visible":true,"depth":500,"userdefinedDepth":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritVisibility":true,"inheritSubLayers":true,"gridX":32,"gridY":32,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":"_filter_gradient","properties":[
        {"type":1,"name":"g_GradientColour1","value":"#FFEBCE87",},
        {"type":1,"name":"g_GradientColour2","value":"#FF7F6F49",},
        {"type":0,"name":"g_GradientPosition1","value":"0.5",},
        {"type":0,"name":"g_GradientPosition1","value":"1",},
        {"type":0,"name":"g_GradientPosition2","value":"0.5",},
        {"type":0,"name":"g_GradientPosition2","value":"0",},
        {"type":0,"name":"g_GradientMode","value":"0",},
      ],},
  ],
  "inheritLayers": false,
  "creationCodeFile": "",
  "inheritCode": false,
  "instanceCreationOrder": [],
  "inheritCreationOrder": false,
  "sequenceId": null,
  "roomSettings": {
    "inheritRoomSettings": false,
    "Width": 320,
    "Height": 180,
    "persistent": false,
  },
  "viewSettings": {
    "inheritViewSettings": false,
    "enableViews": false,
    "clearViewBackground": false,
    "clearDisplayBuffer": true,
  },
  "physicsSettings": {
    "inheritPhysicsSettings": false,
    "PhysicsWorld": false,
    "PhysicsWorldGravityX": 0.0,
    "PhysicsWorldGravityY": 10.0,
    "PhysicsWorldPixToMetres": 0.1,
  },
  "parent": {
    "name": "Demos",
    "path": "folders/Rooms/BE/Demos.yy",
  },
}