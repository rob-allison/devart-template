## Two Colour Transition

The flowers will have an inner colour and an outer colour, each colour coded by a 512 bit string of bDNA. To transition from inner to outer colour within the flower, a masking bit vector is used. The two digital 'protein' sequences from the two bDNA strings can be combined according to the mask - 0=take from inner 'protein', 1=take from outer 'protein' - and a third colour is produced:

![Masking](../project_images/masking.png?raw=true "Masking")

By starting the mask with all 0s, and randomly setting bits until ending with all 1s, a smooth colour transition can be made from inner to outer colour:

![Transition](../project_images/masking2.png?raw=true "Transition")

More examples:

![Examples](../project_images/masking3.png?raw=true "Examples")

## Flower Growth

Using the logical scaffolding developed previously, and controlling the 'opacity' (from all 0s to all 1s) of the mask with petal age and generation, a convincing flower growth animation is produced:

![Flower Growth](../project_images/flowergrow.png?raw=true "Flower Growth")

https://www.youtube.com/watch?v=TEU08z6RXc4
