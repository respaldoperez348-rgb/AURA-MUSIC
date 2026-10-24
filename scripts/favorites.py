#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
import os
import json

FAV_PATH = os.path.expanduser("~/.config/quickshell/favorites.json")

def load_favs():
    if not os.path.exists(FAV_PATH):
        return []
    try:
        with open(FAV_PATH, "r", encoding="utf-8") as f:
            data = json.load(f)
            return data if isinstance(data, list) else []
    except Exception:
        return []

def save_favs(favs):
    os.makedirs(os.path.dirname(FAV_PATH), exist_ok=True)
    temp_path = FAV_PATH + ".tmp"
    with open(temp_path, "w", encoding="utf-8") as f:
        json.dump(favs, f, ensure_ascii=False, indent=2)
    os.replace(temp_path, FAV_PATH)

def main():
    if len(sys.argv) < 2:
        print(json.dumps(load_favs(), ensure_ascii=False))
        return

    action = sys.argv[1].lower()

    if action == "list":
        print(json.dumps(load_favs(), ensure_ascii=False))

    elif action == "toggle" and len(sys.argv) > 2:
        raw = sys.argv[2]
        favs = load_favs()
        try:
            song = json.loads(raw)
            song_id = song.get("id") or song.get("url")
            existing_idx = next((i for i, x in enumerate(favs) if (x.get("id") or x.get("url")) == song_id), -1)
            
            if existing_idx != -1:
                # Ya existía, lo quitamos
                favs.pop(existing_idx)
            else:
                # No existía, lo añadimos al inicio
                favs.insert(0, song)
            
            save_favs(favs)
            print(json.dumps(favs, ensure_ascii=False))
        except Exception as e:
            print(json.dumps(favs, ensure_ascii=False))

    elif action == "is_fav" and len(sys.argv) > 2:
        song_id = sys.argv[2]
        favs = load_favs()
        is_f = any((x.get("id") or x.get("url")) == song_id for x in favs)
        print("true" if is_f else "false")

    else:
        print(json.dumps(load_favs(), ensure_ascii=False))

if __name__ == "__main__":
    main()
