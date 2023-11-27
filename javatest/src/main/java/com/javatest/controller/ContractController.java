package com.javatest.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.javatest.ContractRequest;
import com.javatest.entity.Contract;
import com.javatest.entity.Contract.ContractType;
import com.javatest.service.ContractService;

@RestController
@RequestMapping("/contracts")
public class ContractController {

    private final ContractService contractService;

    @Autowired
    public ContractController(ContractService contractService) {
        this.contractService = contractService;
    }

    @PostMapping("/create")
    public ResponseEntity<Contract> createContract(@RequestParam Long customerId,
                                                   @RequestParam ContractType contractType) {
        Contract createdContract = contractService.createContract(customerId, contractType);
        return new ResponseEntity<>(createdContract, HttpStatus.CREATED);
    }

    @PostMapping
    public ResponseEntity<String> createContract(@RequestBody ContractRequest contractRequest) {
        contractService.createContract(contractRequest);
        return ResponseEntity.ok("Contract created successfully.");
    }
    
    @GetMapping("/search")
    public ResponseEntity<List<Contract>> searchContracts(
            @RequestParam(name = "customerName", required = false) String customerName,
            @RequestParam(name = "startDate", required = false) LocalDate startDate,
            @RequestParam(name = "contractType", required = false) String contractType,
            @RequestParam(name = "userType", required = false) String userType) {

        try {
            // Implementa la logica di ricerca dei contratti
            List<Contract> contracts = contractService.searchContracts(customerName, startDate, contractType, userType);

            return new ResponseEntity<>(contracts, HttpStatus.OK);
        } catch (Exception e) {
            // Gestisci eventuali eccezioni e restituisci una risposta adeguata
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
