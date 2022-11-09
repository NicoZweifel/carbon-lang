// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// RUN: %{explorer-run}
// RUN: %{explorer-run-trace}
// CHECK:STDOUT: result: 10

package ExplorerTest api;


interface Iterator(T:! Type)
{
    fn Current[me: Self]() -> T;
    fn Next[addr me: Self*]() -> bool;
}


interface Iterable(T:!Type, I:! Iterator(T))
{
    fn GetIterator[me: Self]() -> I ;
}

class Counter  {
    var count: i32;
    var max: i32;
}

impl Counter as  Iterator(i32) {
    fn Next[addr me: Self*]() -> bool {
        var old: auto = (*me).count;
        if(old == (*me).max){
            return false;
        }
        (*me).count = old + 1;
        return true;
    }
    fn Current[me: Self]() -> i32 {
        return me.count;
    }
}

class Countable {
    fn Create() -> Self {
        var counter: Counter = {.count = 0, .max = 10};
        return { .counter = counter};
    }
    var counter: Counter;
}

impl Countable as Iterable(i32,Counter){
    fn GetIterator[me: Self]() -> Counter {
        return me.counter;
    }
}


fn Main() -> i32 {
    let testImpl: Countable = Countable.Create();
    var iterator: Counter = testImpl.(Iterable(i32,Counter).GetIterator)();
    var x: i32 = iterator.(Iterator(i32).Current)();
    Print("{0}",x);
    while (iterator.(Iterator(i32).Next)()) {
        x = iterator.(Iterator(i32).Current)();
        Print("{0}",x);
    }
    return iterator.(Iterator(i32).Current)();
}
