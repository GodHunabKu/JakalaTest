package com.javatest.service;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javatest.ContractRequest;
import com.javatest.entity.Contract;
import com.javatest.entity.Contract.ContractType;
import com.javatest.entity.Customer;
import com.javatest.repository.ContractRepository;
import com.javatest.repository.CustomerRepository;

@Service
public class ContractService {

    private final ContractRepository contractRepository;
    private final CustomerRepository customerRepository;

    @Autowired
    public ContractService(ContractRepository contractRepository, CustomerRepository customerRepository) {
        this.contractRepository = contractRepository;
        this.customerRepository = customerRepository;
    }

    public Contract createContract(Long customerId, ContractType contractType) {
        Customer customer = customerRepository.findById(customerId)
                .orElseThrow(() -> new IllegalArgumentException("Customer not found"));

        Contract contract = new Contract();
        contract.setCustomer(customer);
        contract.setContractType(contractType);

        return contractRepository.save(contract);
    }

    public void createContract(ContractRequest contractRequest) {
        Customer customer = customerRepository.findById(contractRequest.getCustomerId())
                .orElseThrow(() -> new IllegalArgumentException("Customer not found"));

        Contract contract = new Contract();
        contract.setCustomer(customer);
        contract.setContractType(contractRequest.getContractType());

        contractRepository.save(contract);
    }
    
    public List<Contract> searchContracts(String customerName, LocalDate startDate, String contractType, String userType) {
        List<Contract> contracts = contractRepository.findAll(); // Use contractRepository to fetch contracts

        return contracts.stream()
                .filter(contract -> isMatchingCustomer(contract, customerName, userType))
                .filter(contract -> startDate == null || contract.getStartDate().isEqual(startDate))
                .filter(contract -> contractType == null || contract.getContractType().name().equalsIgnoreCase(contractType))
                .collect(Collectors.toList());
    }

    private boolean isMatchingCustomer(Contract contract, String customerName, String userType) {
        if (customerName == null && userType == null) {
            return true;
        }

        Customer customer = contract.getCustomer();
        if (customer == null) {
            return false;
        }

        if (customerName != null && !customer.getName().equalsIgnoreCase(customerName)) {
            return false;
        }

        if (userType != null && customer.getUserType() != null && !customer.getUserType().equalsIgnoreCase(userType)) {
            return false;
        }

        return true;
    }

}
