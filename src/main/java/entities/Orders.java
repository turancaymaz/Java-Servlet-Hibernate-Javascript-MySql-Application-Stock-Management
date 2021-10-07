package entities;

import lombok.Data;

import javax.persistence.*;
import java.util.Date;

@Data
@Entity
public class Orders {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int order_id;

    private int order_customer_id;

    @Column(name = "order_product_id")
    private int order_product_id;

    private int order_count;
    private long order_receipt;
    private int order_status;

    @OneToOne
    private Products product;

    @OneToOne
    private Customer customer;

}
