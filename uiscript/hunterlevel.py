# -*- coding: utf-8 -*-
# HUNTER TERMINAL - SOLO LEVELING EDITION v2.0
# Layout minimale - La grafica dinamica viene creata nel codice Python

BOARD_WIDTH = 500
BOARD_HEIGHT = 520

window = {
    "name": "HunterLevelWindow",
    "style": ("movable", "float",),
    "x": 0, "y": 0,
    "width": BOARD_WIDTH,
    "height": BOARD_HEIGHT,
    "children":
    (
        {
            "name": "BaseWindow",
            "type": "window",
            "x": 0, "y": 0,
            "width": BOARD_WIDTH,
            "height": BOARD_HEIGHT,
        },
    ),
}