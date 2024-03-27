using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class playermovement : MonoBehaviour
{
    public float speed = 5;
    private Rigidbody2D rb;
    public float jumpforce = 5;
    private bool isgrounded = false;

    private Animator anim;
    private Vector3 rotation;

    public GameObject panel;
    public GameObject kamera;
    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
        anim = GetComponent<Animator>();
        rotation = transform.eulerAngles;
    }

    
    void Update()
    {
        float richtung = Input.GetAxis("Horizontal");

        if (richtung != 0)
        {
            anim.SetBool("IsRunning", true);
        }
        else
        {
            anim.SetBool("IsRunning", false);
        }

        if(richtung < 0)
        {
            transform.eulerAngles = rotation - new Vector3(0, 180, 0);
        }

        if (richtung > 0)
        {
            transform.eulerAngles = rotation;
        }

        if(isgrounded == false)
        {
            anim.SetBool("IsJumping", true);
        }
        else
        {
            anim.SetBool("IsJumping", false);
        }

        Vector3 movement = new Vector3(Input.GetAxis("Horizontal"), 0f, 0f);
        transform.position += movement * Time.deltaTime * speed;

        if (Input.GetKeyDown(KeyCode.Space) && isgrounded)
        {
            rb.AddForce(Vector2.up * jumpforce, ForceMode2D.Impulse);
            isgrounded = false;
        }

        kamera.transform.position = new Vector3(transform.position.x, 0, -10);

    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        if(collision.gameObject.tag == "ground")
        {
            isgrounded = true;
        }
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        if(other.gameObject.tag == "Spike")
        {
            panel.SetActive(true);
            Destroy(gameObject);
        }

        if (other.gameObject.tag == "Finish")
        {
            SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
        }
    }

}
