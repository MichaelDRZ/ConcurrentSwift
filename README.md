# ConcurrentSwift
ConcurrentSwift is a multithreaded implementation of common higher-order functions such as map, compactMap and filter that are applied to the collection types Array, Set and Dictionary. 

<!-- ABOUT THE PROJECT -->
## About The Project

ConcurrentSwift is intended to speed up operations on large collections by providing a multithreaded implementation of higher-order standard functions. 

<!-- USAGE EXAMPLES -->
## Usage

The functions provided in this framework can be used exactly like the standard functions of the Swift Foundation. The only difference is that closures passed as parameters are not allowed to throw errors for the sake of simplicity.

<!-- PERFORMANCE -->
## Performance
The performance of ConcurrentSwift depends on the size of the collection, the complexity of the applied closure and the device the code is running on. ConcurrentSwift yields the best performance gains with large collections and complex closures running on powerful multicore processors.

If you would like to know if ConcurrentSwift improves performance in your use case, you can either use (or modify) the provided performance test functions or you can write you own test.

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch
3. Commit your Changes
4. Push to the Branch
5. Open a Pull Request

<!-- LICENSE -->
## License

Distributed under the [MIT License](https://opensource.org/licenses/MIT).
