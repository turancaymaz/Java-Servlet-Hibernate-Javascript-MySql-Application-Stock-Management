package entities;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
@Data
public class Products {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
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
