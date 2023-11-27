package com.javatest;

import com.javatest.entity.Contract.ContractType;

public class ContractRequest {

    private Long customerId;
    private ContractType contractType;

    public Long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Long customerId) {
        this.customerId = customerId;
    }

    public ContractType getContractType() {
        return contractType;
    }

    public void setContractType(ContractType contractType) {
        this.contractType = contractType;
    }
}