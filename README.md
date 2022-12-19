# Fuzzy Controller tuning using a genetic algorithm

Classical controls are a vital and powerful part of robotics. However, they come
with the necessity of creating a matehmatical model of the robotic system. While
in many cases this part of the system is already solved as part of the design of
the system, there are many cases where the system is incredibly complex and
difficult to model. Fuzzy controllers, on the other hand, allow human intuition
to be the core of the controller rather than a mathematical model. This happens
by encoding human intuition into rules, which are then tuned to make the system
behavior work.

### Project goal

The goal of this project is to implement a fuzzy controller, then implement a
genetic algorithm to tune the fuzzy controller's parameters.

### Methodology

#### Rocky

Rocky is an inverted pendulum system designed for the ESA course at Olin. In
ESA, physical Pololu Balboa kits are used to teach controls, but for this
project, we will be working with a Matlab simulation. There are two main inputs:
pendulum angle (theta), and cart position. The derivative of the two 
abformentioned inputs are also fed into the system. The output of the system is 
the force exerted onto the cart.

#### Fuzzy Inference system

The fuzzy inference system contains three main parts: the fuzzifier,
defuzzifier, and the fuzzy inference rules. The fuzzifier takes the crisp input
and transforms it into a fuzzy input. The fuzzy inference rules convert the
fuzzy input into a fuzzy output. Finally, the defuzzifier transforms the fuzzy
output back into a crisp number.

Let's start by exploring the fuzzy inference rules. These rules are the human
intuition encoded into "If then" statements. For example, in Rocky, one set of
intuitive rules can be "If *theta* is *negative*, then *force* is *negative*",
and "If *theta* is *positive*, then *force* is *positive*". Here, *theta* and
*force* are our input and output variables, and *positive* and *negative* are
the fuzzy membership sets our inputs and outputs can be in. From this set of
rules, a fuzzy input that is `[0.1, 0.9]` (0.1 positive, 0.9 negative) would
have the fuzzy output `[0.1, 0.9]` (0.1 positive, 0.9 negative).

The fuzzification works through membership functions. Every membership set, such
as positive or negative, has a membership function. This can look like an S
curve for the case of positive or negative, or a bell curve, for "distance from
a value". The membership function maps crisp values to the membership to that
set. So, the membership functions together assign a crisp value membership to
every set, which is the fuzzy value. For decision making, these membership
functions often come through polling many people on their intuition. For
example, for banking systems, membership functions may come by polling 100
bankers. For control systems, though, these membership functions are often the
tuning knobs that allow us to tweak the system to be just right.

Defuzzification works similarly. Again, each fuzzy set has membership functions,
just like fuzzification. However, this time, we want to convert a fuzzy value,
which has membership in multiple sets, into a singular crisp value. We do this
by creating the shape that is the intersection of the membership function and
the values below the membership of a set. For example, if force is 0.3 negative,
we would intersect the negative membership function with the function `y <=
0.3`. We then combine all of the shapes from each set, then find the centroid of
the total combined shape. The X coordinate of the centroid is our crisp output.

These three steps together can be used to create a Fuzzy Inference system, which
is the core of a fuzzy controller.

#### Genetic algorithm

Manual tuning of the system yielded marginally functional results. While the
rules are intuitive, the tuning is slightly less intuitive. While people may
know that the cart should move left to balance a pendulum leaning left, how far
left? And what is that in force?

Instead, another option is to use a genetic algorithm to tune the system. This
works by spawning multiple potential sets of membership functions. Each one of
these is tested against a cost function, then the sets that have the minimal
cost are chosen to move to the next generation. In the next generation, the
surviving sets are mutated and tested again. Over time, this acts as a psuedo
gradient descent where the gradient is unknown, therefore many directions are
tried as a trial and error.

The cost function used was a combination of the RMS of the pendulum angle and
the RMS of the cart position. The RMS of the pendulum angle is weighted
significnatly more than the cart position because an extreme pendulum angle
means the control system failed, while an extreme cart position means the
control system needs to converge to zero.

### Future improvements

The biggest design decision that I regret from this project is choosing to use
Matlab. Matlab provided an excellent starting point, as the fuzzy logic toolbox
and the previous work done for ESA allowed the initial FIS to be created
relatively quickly and painlessly. However, when it came to debugging and
optimizing the system, working within Matlab and Simulink's environments became
clunky and inconveinent. A more flexible and friendly environment like Python
would have been a much better choice, especially when it came to developing the
genetic algorithm. While Matlab provides many examples and built in functions, I
found the tradeoff to be significnatly in reliability and runtime speed. I am
much more comfortable debugging Python's error meessages and finding
optimizations in a Python and Linux environemnt rather than a Windows and Matlab
environment. Furthermore, many of the runs of only a few generations of the
genetic algorithm took upwards of half an hour. I'm certain that a similar
computational load, when developed properly in Python, would take a fraction of
that time because the biggest time sink was the Simulink API calls. Every run of
the cost function required a new Simulink API call, which spawned a new Simulink 
enviornment. In future projects similar to this, I would make sure to explore
new algorithms and theory in environments where I am more familiar, comfortable,
and confident in, especially because my learning goals center around learning
new algorithms rather than new programming languages.

