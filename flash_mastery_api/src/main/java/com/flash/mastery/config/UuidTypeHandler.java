package com.flash.mastery.config;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.MappedJdbcTypes;
import org.apache.ibatis.type.MappedTypes;

/**
 * Type handler for UUID type.
 * Converts between UUID (Java) and VARCHAR/UUID (PostgreSQL).
 */
@MappedTypes(UUID.class)
@MappedJdbcTypes(JdbcType.VARCHAR)
public class UuidTypeHandler extends BaseTypeHandler<UUID> {

    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, UUID parameter, JdbcType jdbcType)
            throws SQLException {
        ps.setObject(i, parameter);
    }

    @Override
    public UUID getNullableResult(ResultSet rs, String columnName) throws SQLException {
        final var value = rs.getObject(columnName);
        if (value == null) {
            return null;
        }
        if (value instanceof final UUID uuid) {
            return uuid;
        }
        if (value instanceof final String string) {
            return UUID.fromString(string);
        }
        return UUID.fromString(value.toString());
    }

    @Override
    public UUID getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        final var value = rs.getObject(columnIndex);
        if (value == null) {
            return null;
        }
        if (value instanceof final UUID uuid) {
            return uuid;
        }
        if (value instanceof final String string) {
            return UUID.fromString(string);
        }
        return UUID.fromString(value.toString());
    }

    @Override
    public UUID getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        final var value = cs.getObject(columnIndex);
        if (value == null) {
            return null;
        }
        if (value instanceof final UUID uuid) {
            return uuid;
        }
        if (value instanceof final String string) {
            return UUID.fromString(string);
        }
        return UUID.fromString(value.toString());
    }
}
