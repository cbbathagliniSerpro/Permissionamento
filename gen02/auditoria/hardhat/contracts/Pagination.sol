// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.28;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

library Pagination {

    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableSet for EnumerableSet.AddressSet;

    error InvalidPaginationParameter();

    /**
     * @notice Calcula os limites de uma página
     * @param totalItems Total de itens no conjunto
     * @param pageNumber Número da página (começando em 1)
     * @param pageSize Tamanho da página
     * @return start Índice inicial da página
     * @return stop Índice final da página
     */
    function getPageBounds(
        uint256 totalItems,
        uint256 pageNumber,
        uint256 pageSize
    ) internal pure returns (uint256 start, uint256 stop) {
        if (pageNumber == 0 || pageSize == 0) {
            revert InvalidPaginationParameter();
        }

        start = (pageNumber - 1) * pageSize;
        if (start >= totalItems) {
            return (0, 0);
        }

        stop = start + pageSize;
        if (stop > totalItems) {
            stop = totalItems;
        }

        return (start, stop);
    }

    /**
     * @notice Retorna uma página de valores do tipo uint
     * @param set O conjunto de dados a ser paginado
     * @param pageNumber Número da página (começando em 1)
     * @param pageSize Tamanho da página
     * @return Uma matriz com os valores da página solicitada
     */
    function getUintPage(
        EnumerableSet.UintSet storage set,
        uint256 pageNumber,
        uint256 pageSize
    ) internal view returns (uint256[] memory) {
        if (pageNumber == 0 || pageSize == 0) {
            revert InvalidPaginationParameter();
        }

        uint256 startIndex = (pageNumber - 1) * pageSize;
        uint256 totalElements = set.length();

        if (startIndex >= totalElements) {
            return new uint256[](0);
        }

        uint256 endIndex = startIndex + pageSize;
        if (endIndex > totalElements) {
            endIndex = totalElements;
        }

        uint256 resultLength = endIndex - startIndex;
        uint256[] memory result = new uint256[](resultLength);

        for (uint256 i = 0; i < resultLength; i++) {
            result[i] = set.at(startIndex + i);
        }

        return result;
    }

    /**
     * @notice Retorna uma página de valores do tipo address
     * @param set O conjunto de dados a ser paginado
     * @param pageNumber Número da página (começando em 1)
     * @param pageSize Tamanho da página
     * @return Uma matriz com os valores da página solicitada
     */
    function getAddressPage(
        EnumerableSet.AddressSet storage set,
        uint256 pageNumber,
        uint256 pageSize
    ) internal view returns (address[] memory) {
        if (pageNumber == 0 || pageSize == 0) {
            revert InvalidPaginationParameter();
        }

        uint256 startIndex = (pageNumber - 1) * pageSize;
        uint256 totalElements = set.length();

        if (startIndex >= totalElements) {
            return new address[](0);
        }

        uint256 endIndex = startIndex + pageSize;
        if (endIndex > totalElements) {
            endIndex = totalElements;
        }

        uint256 resultLength = endIndex - startIndex;
        address[] memory result = new address[](resultLength);

        for (uint256 i = 0; i < resultLength; i++) {
            result[i] = set.at(startIndex + i);
        }

        return result;
    }
}
