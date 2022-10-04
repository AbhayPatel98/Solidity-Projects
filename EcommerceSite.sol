// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Ecommerce {  //Build Ecommerce smart contarct. 

    struct Product {  // Store Product with all description by using struct.
      string title;
      string description;
      address payable seller;
      uint  price;
      uint  productId;
      address buyer;
      bool delivered;
    }
    uint Counter = 1;  //Product id .
    Product[] public products; // Save all description in dynamic array[].

    event registered_Product(string title, uint productId, address seller);
    event bought(uint productId, address buyer);
    event delivered(uint productId); 



    function registerProduct(string memory _title, string memory _description, uint _price) public {
       //Register product from struct details.
       require(_price>0, "Price should be greater than zero"); //condition 
       Product memory tempProduct;
       tempProduct.title = _title;
       tempProduct.description = _description;
       tempProduct.price = _price * 10**18;
       tempProduct.seller = payable(msg.sender);
       tempProduct.productId = Counter;
       Counter++;
       products.push(tempProduct); // push all details in dynamic array.
       emit registered_Product(_title, tempProduct.productId, msg.sender);
       //counter will change continuously that's why we trigger temProduct.productId.
    }

    function buyer(uint productId) payable public {
        require(products[productId-1].price == msg.value,"please pay the exact price");
        require(products[productId-1].seller != msg.sender, "seller can not buy");
//product stored in ID vlaue 1 but index of that stored product is zero 0 that's
//why we use [productID-1] to get details of 0 index.      
        products[productId-1].buyer = msg.sender;  
        emit bought(productId, msg.sender);
    }

    function delivery(uint productId) public {
        require(products[productId-1].buyer == msg.sender, "only buyer can confirm it");
        products[productId-1].delivered = true;
        products[productId-1].seller.transfer(products[productId-1].price);
        emit delivered(productId);
    }

}