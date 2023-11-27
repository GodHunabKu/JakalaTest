package com.javatest.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.javatest.entity.Contract;
import com.javatest.entity.Customer;
import com.javatest.service.CustomerService;

@RestController
@RequestMapping("/customers")
public class CustomerController {

    private final CustomerService customerService;

    @Autowired
    public CustomerController(CustomerService customerService) {
        this.customerService = customerService;
    }

    @GetMapping
    public ResponseEntity<List<Customer>> getAllCustomers() {
        List<Customer> customers = customerService.getAllCustomers();
        return new ResponseEntity<>(customers, HttpStatus.OK);
    }

    @GetMapping("/{customerId}/contracts")
    public ResponseEntity<List<Contract>> getContractsByCustomerId(@PathVariable Long customerId) {
        try {
            Customer customer = customerService.getCustomerById(customerId)
                    .orElseThrow(() -> new RuntimeException("Customer not found"));

            List<Contract> contracts = customer.getContracts();
            return new ResponseEntity<>(contracts, HttpStatus.OK);
        } catch (Exception e) {
            // Handle exceptions and return an appropriate response
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    @PostMapping("/{customerId}/contracts")
    public ResponseEntity<?> createContract(@PathVariable Long customerId, @RequestBody Contract contract) 
    {
        return new ResponseEntity<>(HttpStatus.CREATED);
    }
}
