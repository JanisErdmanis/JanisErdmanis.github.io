+++
date = "2017-11-16"
tags = ["julia", "python"]
rss = "I used to be a Python advocate as having an interpreter, meaningful error messages, docstrings, and easy library installation made the scope of what I could build expand tremendously. But in 2015, the Cython, Numba or C interop story became unbearable for my MSc thesis project, and I made a plunge into Julia, and I never looked back. As saying says, you come to Julia for performance and stay there multiple dispatch, type system, REPL, Pkg and other neat things."
+++

# Julia type system and multiple dispatch

Most programmers are familiar with productivity gains to have an interpreter, meaningful error messages, docstrings, and an easy procedure to make and install libraries. That is why Python was such a good thing in its time, and I was a strong advocator for its use in science. But then, in 2015, I made a switch to Julia (then it was version 0.3), and I have never looked back. So I decided to make a blog post about Julia's essentials to give the real experience of what I value most about it: dynamic multiple dispatch, its type system, performance and ease of use
in multicore environments.

## Multiple dispatch

Every useful computer program applies some operations to input and generates an output which can be represented in a list of machine instructions. Fortunately, we can make these programs by abstracting data structures into types and operations which act on them. Depending on the way we organise types and operations, we can write code in an object-oriented paradigm (OOP) or functional/imperative paradigm (FP) as `myfoo.hello()` and `hello(myfoo)` is the same thing. Nevertheless, of the chosen paradigm, we spend more time on organising than on the benefits of the creative process.

To see that, imagine that we have a set of types and a set of operations that act on these types. Sometimes we need to add more operations and ensure they work properly on all types, or we need to add more types and ensure that all operations work properly on them. Sometimes, however, we need to add both - and there lies the problem. Most of the mainstream programming languages only provide good tools to add new types and operations to an existing system without changing existing code. That is called the *expression problem*.

Both - FP and OOP - suffer from the expression problem. In OOP, types can be easily added by class inheritance, but to add new operations (methods) to existing types, you need to edit the class where it is defined and decide under which class the method fits, taking a lot of
mental effort; in FP operations are easy to add, but you would be forced to name them like `plusmytypeAmytypeB(x, y)` to keep track of what they do. Therefore it is hard to reuse existing operations for your newly defined types. (Note that Rust comes around this issue with traits and the ability to implement multiple traits for a single type. In Java, on the other hand, one would need to edit the interface to support new behaviours).

For example, consider what it would take to make a function written for integer and floating point types `myfuncInt64Float64(x,y)` available for your own types `BigInt` and `BigFloat`. Firstly you would copy and paste the function's code, change its name call and return types; for every function call on integer and floating types, you would need to replace the appropriate function call corresponding to the new types `BigInt` and `BigFloat`. In some situations, automating this process could be useful, but it would take a lot of effort to think about how the code can be generalised. It would be easier if types would not need to be specified, including function names, and the compiler (or interpreter) would choose the right function depending on passed types at runtime. One way to accomplish that is by writing function selection mechanisms or *generic functions* yourself, but it would be much nicer
if the *generic functions* would be generated automatically from the functions you had already in the namespace - this is where dynamic multiple dispatch comes in handy.

Dynamic multiple dispatch is a function selection mechanism which chooses the right function implementation (function with specified types) depending on their passed types on runtime (the selection mechanism usually is not present at program running time because the compiler can
reason the right type at compilation time). While it is similar to C++ overloading, it does not suffer from pitfalls which come from static rather than dynamic dispatch (I will discuss that in the next subsection). So dynamic multiple dispatch makes it possible to reuse a lot of code when adding new operations for existing types, as all functions would share the same names.

But that is not enough! Adding new types is still hard because we usually want to base our type on the existing set of operations that type that already work on it and add only relevant data structure or operational differences. So that justifies the need for type inheritance and multiple dispatch over abstract types, which is the final ingredient to solve the expression problem. Interestingly the solution is based on extensive use of polymorphism as functions for different types share the same names and inheritance. So is Julia OOP or FP language?

## Static dispatch

C++ overloading is an example of static multiple dispatch because the right types must be guessed at the compilation time. But as I told you previously, that introduces pitfalls. I will try to illustrate them on a simple Julia program as my C++ is quite rusty:

```julia
abstract Bar
type SubBar1 <: Bar end
type SubBar2 <: Bar end

fubar(b::Bar) = "b is a Bar"
fubar(b::SubBar1) = "b is a SubBar1"
fubar(b::SubBar2) = "b is a SubBar2"

function foo(x::Bar)
    return fubar(x) 
end
```
If Julia would do static dispatch like C++, the result of calling function `foo(x)` for both `x` types `SubBar1` and `SubBar2` would be "b is a Bar". That does not help with the expression problem much, as we would need to define function `foo(x)` for each new type.

In dynamic dispatch, appropriate methods for `x` are chosen, returning either "b is a SubBar1" or "b is a SubBar2". And that is very useful for creating your types on top of existing ones and changing only meaningful parts of code without actually modifying it. That makes the code highly reusable in Julia and is a reason why C++ people could say that *Julia is C++ done right*.

## Single dynamic dispatch

The behaviour of single dynamic dispatch can be simulated in an object-oriented programming language like Python by transforming:

    hello(myfoo) -> myfoo.hello()

So what difference would that make? The previous example can be implemented very easily as follows:

```python
class Bar:
    pass
class SubBar1(Bar):
    pass
class SubBar2(Bar):
    pass

Bar.fubar = lambda self: println("Bar")
SubBar1.fubar = lambda self: println("SubBar1")
SubBar2.fubar = lambda self: println("SubBar2")

def foo(x):
    x.fubar()
```

so calling `foo(x)` with the object of `SubBar1` or `SubBar2` would result in the same behaviour as in dynamic dispatch.

The difficulty lies in the problem that it is only a single dispatch. For example, consider classes which implement different kinds of matrices - ordinary, sparse, triangular - and you would like to implement multiplication between them. A code in Python would look as follows:

```python
class Matrix:
    pass
class Sparse:
    pass
class Triangular:
    pass

def mul_Matrix_Sparse(x,y):
    pass
def mul_Sparse_Matrix(x,y):
    pass
def mul_Matrix_Triangular(x,y):
    pass
def mul_Triangular_Matrix(x,y):
    pass
def mul_Sparse_Triangular(x,y):
    pass
def mul_Triangular_Sparse(x,y):
    pass

### Ups! Forgot to implement multiplicaction by objects themselves

def __mul__Matrix(x,y):
    if isinstace(y,Sparse):
        return mul_Matrix_Sparse(x,y)
    elseif isinstace(y,Triangular):
        return mul_Matrix_Triangular(x,y)
    else
        assert("Not implemented")
Matrix.__mul__ = __mul__Matrix

def __mul__Sparse(x,y):
    if isinstance(y,Matrix):
        return mul_Sparse_Matrix(x,y)
    elseif isinstance(y,Triangular):
        return mul_Sparse_Triangular(x,y)
    else:
        assert("Not implemented")
Sparse.__mul__ = __mul__Sparse

def __mul__Triangular(x,y):
    is isinstance(y,Matrix):
        return mul_Triangular_Matrix(x,y)
    elseif isinstance(y,Sparse):
        return mul_Triangular_Sparse(x,y)
    else:
        assert("Not implemented")
Triangular.__mul__ = __mul__Triangular
```

The ugly part of the code above is the selection mechanism which is like a stone on your shoulders. For example, consider if you would like to implement a vector type and multiplications with all present objects. Firstly you would have to write corresponding functions which are necessary work. Then for each object selection mechanism, you would have to add `isinstance(y, Vector),` which requires editing existing code. Also, adding operations allowing multiplying the same objects would require the same amount of work, and thus, we turn to the expression problem.

On the contrary, the Julia code above would look as follows:
```julia
abstract Matrix
abstract Sparse
abstract Triangular

*(x::Matrix,y::Sparse) = ...
*(x::Matrix,y::Triangular) = ...
*(x::Sparse,y::Triangular) = ...
*(x::Sparse,y::Matrix) = ...
*(x::Triangular,y::Matrix) = ...
*(x::Triangular,y::Sparse) = ...
```
Not only is the code much shorter and easier to write but also much easier to manage as we don't need to write a dispatching mechanism ourselves. That is especially advantageous as to add new types and operations; we need to edit the code above. Therefore we have seen that dynamic dispatch over multiple arguments is essential for solving the expression problem.

## Resources

I was too lazy to research why I feel so uncomfortable doing stuff again in Python. Expression problem

- <http://matthewrocklin.com/blog/work/2014/02/25/Multiple-Dispatch>
- <https://medium.com/@Jernfrost/defining-custom-units-in-julia-and-python-513c34a4c971>
- <https://discourse.julialang.org/t/dynamic-dispatch/6963>
- <https://news.ycombinator.com/item?id=15565933>
- <https://medium.com/@franksands/why-is-object-oriented-programming-useful-with-an-rpg-example-javascript-and-java-670e2d1c5505>
- <http://www.stochasticlifestyle.com/type-dispatch-design-post-object-oriented-programming-julia/>
- <https://medium.com/@cscalfani/goodbye-object-oriented-programming-a59cda4c0e53>
- <http://www.stochasticlifestyle.com/like-julia-scales-productive-insights-julia-developer/>
- <http://www.stochasticlifestyle.com/comparison-differential-equation-solver-suites-matlab-r-julia-python-c-fortran/>
- <https://devblogs.nvidia.com/parallelforall/gpu-computing-julia-programming-language/>
- <http://nbviewer.jupyter.org/gist/StefanKarpinski/b8fe9dbb36c1427b9f22>
- <https://discourse.julialang.org/t/julia-motivation-why-werent-numpy-scipy-numba-good-enough/2236/10>
- <https://en.wikipedia.org/wiki/Expression_problem>
- <https://eli.thegreenplace.net/2016/the-expression-problem-and-its-solutions/>
- <https://eli.thegreenplace.net/2016/a-polyglots-guide-to-multiple-dispatch-part-2>
- <https://blog.logentries.com/2016/12/solving-the-expression-problem/>
