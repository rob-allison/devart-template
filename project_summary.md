# Bloom

### Author
* Robert Allison - http://github.com/rob-allison

### Proposal
By using a kind of binary DNA (bDNA) I can treat colour as the expression of a process. Previous experimentation can be found [here](http://www.robertallison.co.uk "Robert Allison").

I propose to create digital flowers, 'grown' from bDNA. There would be a population of such flowers. Visitors would be able to select flowers to breed together and the resulting offspring would be added to the population. Flowers would have a lifespan, and would 'die' after a certain time. During the course of the exhibition the nature of this flower population will shift and change as a result of visitor directed pollination.

The proposal will explore:
* growth - how a simple genetic sequence is translated into a complex structure.
* breeding - how two sequences combine to produce a third that expresses characteristics from its parents.
* selection - how a population as a whole evolves under a selection pressure.

I hope to draw a parallel between DNA and source code, and to show how something almost natural can emerge from the purely computational when iterated to sufficient scale.

This imagery is built up of over-sized pixels or blocks of colour, there is no anti-aliasing or similar attempts to coerce the digital medium into the smoothness of the analogue. It's essential discrete - pixelated - nature is celebrated, not hidden.

### Growth

Three strands of bDNA, or chromosomes, are used to define each flower - one for the outer colour, one the inner, and one to control the transition between inner and outer as the flower grows:

![Growth](project_images/flowergrow4.png?raw=true "Growth")

https://www.youtube.com/watch?v=TEU08z6RXc4

The bDNA is translated one 4 bit codon at a time, each codon coding for a digital 'acid' - the acids are then joined to make a digital 'protein' - the properties of the proteins determine the colours and growth parameters.

```
class Dna extends ListBase<bool> {

  final BitList sequence;

  List<Protein> decode() {
    List<Protein> proteins = new List();
    int i = 0;
    Protein p = new Protein();
    CodonIterator iter = codonIterator;
    while (iter.moveNext()) {
      p.acids[i] = iter.current.decode();
      i++;
      if (i == Protein.length) {
        proteins.add(p);
        i = 0;
        p = new Protein();
      }
    }
    return proteins;
  }
  
  Iterator<Codon> get codonIterator {
    return new CodonIterator(this);
  }
  ...
}
```
### Breeding

By interchanging fragments of bDNA between two flowers, offspring may share traits from their parents:

![Breeding](project_images/breed5.png?raw=true "Breeding")

```
List<Dna> breed(Random rng, List<Dna> a, List<Dna> b) {

  // interchange 40% from a, 40% from b, 20% from both
  List<Dna> result = new List(a.length);
  for (int i = 0; i < a.length; i++) {
    int x = rng.nextInt(100);
    if (x < 40) {
      result[i] = a[i];
    } else if (x < 80) {
      result[i] = b[i];
    } else {
      result[i] = intermingle(rng, a[i], b[i]);
    }
  }
  
  // mutate 10% of the time
  if (rng.nextInt(100) < 10) {
    int i = rng.nextInt(result.length);
    result[i] = mutate(rng, result[i]);
  }

  // swap 10% of the time
  if (rng.nextInt(100) < 10) {
    int i = rng.nextInt(result.length);
    int j = rng.nextInt(result.length);
    Dna x = result[i];
    result[i] = result[j];
    result[j] = x;
  }

  return result;
}
```

### Simulation

This animation simulates a population of flowers, pollinated at random:

http://youtu.be/B_uH1Exdfhw

A Dart cmd line app is also provided at https://github.com/rob-allison/devart-template/blob/master/project_code/bloom/bin/cmdlinepop.dart

### User Interface

The simplest UI would have the population projected onto a screen, with tablets allowing visitors to make their selections. However, a more ambitious approach would use pedastals - 'flower pots' - laid out in the gallery. The top of the pedastal would display the flower as it grows, whilst its sides would show the bDNA.

Each visitor would be given an RFID card that they tap against their two chosen parent flowers, before tapping on one (or more!) empty pots to grow their flowers. The history of the population would be projected onto screens:

![Population](project_images/froom4.png?raw=true "Population")

Visitors become 'worker bees', pollinating this population of flowers as it grows and evolves. 


