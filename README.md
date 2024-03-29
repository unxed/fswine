# fswine
FastStone image viewer 5.7 installation script for Wine

```
curl -sSL https://raw.githubusercontent.com/unxed/fswine/main/fswine.sh > /tmp/fswine.sh && bash /tmp/fswine.sh
```

FastStone 5.7 works on HiDpi. Set screen resolution to 200 DPI in winecfg.

See also:
- https://bugs.winehq.org/show_bug.cgi?id=5129#c40
- https://bugs.winehq.org/show_bug.cgi?id=43490
- https://bugs.winehq.org/show_bug.cgi?id=41438
- https://appdb.winehq.org/objectManager.php?sClass=version&iId=32671
- https://forums.linuxmint.com/viewtopic.php?t=216813
- https://forums.linuxmint.com/viewtopic.php?t=397049
- https://www.faststone.org/FSViewerDetail.htm#History

Why 5.7? 5.5 do not support HiDPI, 5.9 (5.8+?) have buggy crop in Wine. 5.7 seems to be the best choice.
