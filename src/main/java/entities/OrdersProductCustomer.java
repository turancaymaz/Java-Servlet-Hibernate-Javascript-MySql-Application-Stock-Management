package entities;

import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
@Data
public class OrdersProductCustomer {

    @Id
    private int order_id;

    private int order_customer_id;
    private int order_product_id;
    private int order_count;
    private long order_receipt;
    private int order_status;
    private int cu_id;

    private String cu_name;
    private String cu_surname;
    private String cu_company_title;
    private long cu_code;
    private int cu_status;
    private int cu_tax_number;
    private String cu_tax_administration;
    @Column(length = 500)
    private String cu_address;
    private String cu_mobile;
    private String cu_phone;
    @Column(length = 500)
    private String cu_email;
    @Column(length = 32)
    private String cu_password;
    private int p_id;

    private String p_title;
    private int p_buyPrice;
    private int p_salesPrice;
    private int p_code;
    private int p_kdv;
    private int p_unit;
    private int p_quantity;
    private String p_detail;

}
