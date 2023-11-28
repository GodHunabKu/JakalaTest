package com.javatest.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.javatest.entity.Contract;
import com.javatest.entity.Customer;

@Repository
public interface ContractRepository extends JpaRepository<Contract, Long> {
    List<Contract> findByCustomer(Customer customer);
    
    List<Contract> findByCustomerName(String customerName);
}


