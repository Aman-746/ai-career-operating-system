package com.aman.careeros.repository;

import com.aman.careeros.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

/**
 * UserRepository - Interface for database operations on the User entity.
 * By extending JpaRepository, we get standard CRUD operations (save, findById, delete, etc.) for free.
 */
@Repository
public interface UserRepository extends JpaRepository<User, UUID> {
    
    /**
     * Find a user by their email address.
     * Spring Data JPA will automatically generate the SQL for this based on the method name.
     */
    Optional<User> findByEmail(String email);
}
