
1、当block和获取的变量在同一个代码块中，此种情况都可以运行，block就相当于一个函数（code segment）
2、当block未获取外部变量时，此种情况block是NSGlobalBlock，It’s neither on the stack nor the heap, but part of the code segment，like any C function. This works both with and without ARC

3、当block获取外部变量，并且block有进行传递的情况下，在非arc环境中会生成NSStackBlock(存在栈中，随着方法执行完成就消失),此时需要对boclk进行 copy，然后autorelease(就是将NSStackBlock 转换成NSMallocBlock,有栈转移到堆中)，否则会报错，在ARC环境中生成NSMallocBlock(是存在在堆中的,不随方法执行完成而消失)，可以运行。

注意：
a)，在上面的 block 中，我们往 outsideArray 数组中添加了值，但并未修改 outsideArray 自身，这是允许的，因为拷贝的是 outsideArray 自身。
b)，对于 static 变量，全局变量，在 block 中是有读写权限的，因为在 block 的内部实现中，拷贝的是指向这些变量的指针。
c)， __block 变量的内部实现要复杂许多，__block 变量其实是一个结构体对象，拷贝的是指向该结构体对象的指针。

非内联（inline） block 不能直接访问 self，只能通过将 self 当作参数传递到 block 中才能使用，并且此时的 self 只能通过 setter 或 getter 方法访问其属性，不能使用句点式方法。但内联 block 不受此限制。

我提到内联 block 可以直接引用 self，但是要非常小心地在 block 中引用 self。因为在一些内联 block 引用 self，可能会导致循环引用。

block 其实也是一个 NSObject 对象，并且在大多数情况下，block 是分配在栈上面的，只有当 block 被定义为全局变量或 block 块中没有引用任何 automatic 变量时，block 才分配在全局数据段上。 __block 变量也是分配在栈上面的。

在 ARC 下，编译器会自动检测为我们处理了 block 的大部分内存管理，但当将 block 当作方法参数时候，编译器不会自动检测，需要我们手动拷贝该 block 对象。幸运的是，Cocoa 库中的大部分名称中包含”usingBlock“的接口以及 GCD 接口在其接口内部已经进行了拷贝操作，不需要我们再手动处理了。但除此之外的情况，就需要我们手动干预了。

在 ARC 下，对 block 变量进行 copy 始终是安全的，无论它是在栈上，还是全局数据段，还是已经拷贝到堆上。对栈上的 block 进行 copy 是将它拷贝到堆上；对全局数据段中的 block 进行 copy 不会有任何作用；对堆上的 block 进行 copy 只是增加它的引用记数。

如果栈上的 block 中引用了__block 类型的变量，在将该 block 拷贝到堆上时也会将 __block 变量拷贝到堆上如果该 __block 变量在堆上还没有对应的拷贝的话，否则就增加堆上对应的拷贝的引用记数。