## Strategy

There are two major challenges in realising the proposal:

The first is to design a flower growth process that produces digital 'flowers' that have both the complexity and aesthetic qualities we would associate with living organisms, yet are true to their digital roots. The aim here is not to imitate what can already be found in nature, but to find a digital analogy.

The second is the generation, storage, and presentation of/interaction with a population of such flowers. The population needs to be persistant, subject to a 'die-off' process, and may be accessed from anywhere. The creation of new individuals should be protected so they follow the process designed above. Presentation should suggest a taxonomy or at least some attempt to classify individuals in the population. Visitors will need to be able to interact with the population.

## Technology

The generation and storage of a population is an ideal use case for cloud services, eg Google Compute Engine and Cloud Storage. Presentation tasks such as arranging into a taxonomy and handling interaction are best done on the client side, within the browser or with native apps. With computation occuring on both server and client side, it would be nice to use the same language for both - Dart would fit the bill, as it can be run on the server with DartVM and also on the client via Javascript (or directly with Dartium).

![Cloud/Clients](../project_images/cloudclient.jpg?raw=true "Cloud/Clients")



