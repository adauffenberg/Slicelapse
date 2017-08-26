# Slicelapse

This project modifies traditional timelapse to create unique images.

Timelapse.m saves each slice to disk during creation
 - Pros: Max image resolution
 - Cons: Slow, disk heavy, tens of thousands of jpgs on intermediate steps until combined.
 
Timelapse2.m stores the entire image stack and slices in memory
 - Pros: Faster, less mess
 - Cons: Max timelapse resolution goes down. If over 300ish images, probably drop to less than HD
